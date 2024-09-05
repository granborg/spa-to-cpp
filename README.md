# spa-to-cpp

A Rust-based tool to convert a single-page application's files into C++ byte arrays that can be served by lightweight webservers.

## Table of Contents
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
  - [Generating C++ Code](#generating-c-code)
  - [Integration](#integration)
- [Example](#example)
- [Contributing](#contributing)
- [License](#license)

## Features

- Converts SPA files into C++ byte arrays
- Compresses files using GZIP
- Generates C++ header and source files for easy integration
- Provides detailed compression statistics

## Prerequisites

- Rust (for building the tool)
- C++ compiler (for using the generated code)

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/spa-to-cpp.git
   cd spa-to-cpp
   ```

2. Build the project:
   ```
   ./build.sh
   ```

This will create an executable called `webserver_code_generator` in a new directory called `binary`.

## Usage

### Generating C++ Code

The `webserver_code_generator` takes two arguments:
1. The path to your SPA's dist directory
2. The path where you want the output C++ files to go

Example:
```
./binary/webserver_code_generator ../example/dist ../webapp/src
```

This command will generate two files: `webui.h` and `webui.cpp` in the specified output directory.

### Integration

To use the generated files in your C++ project:

1. Include the header file:
   ```cpp
   #include "webui.h"
   ```

2. Obtain the list of `FileManifest` objects:
   ```cpp
   std::vector<FileManifest*> file_manifests;
   getFileManifests(file_manifests);
   ```

Each `FileManifest` contains:
- `route`: The file path
- `bytes`: A pointer to the file bytes
- `bytes_len`: The length of the byte array

When serving these files, use the `Content-Encoding=GZip` header.

## Example

Here's an example of how to add server routes to an ESPAsyncWebserver on the ESP32 embedded platform:

```cpp

## Generating C++ Code
To run the script, first run the build script.
`
./build.sh
`
This will create an executable called webserver_code_generator in a new directory called binary.
This will create an executable called webserver_code_generator in a new directory called binary. webserver_code_generator takes two arguments: The first is the path to your SPA's dist directory. The second is the path where you want the output C++ files to go.

```
granborg@boden spa-to-cpp % ./binary/webserver_code_generator ../example/dist ../webapp/src
Dist folder: ../example/dist
Output files: ../webapp/src/webui.cpp and ../webapp/src/webui.h
Compressed /favicon.ico:
	Raw size:          4.29kb
	Compressed size:   0.86kb
	Compression ratio: 79.84%
Compressed /index.html:
	Raw size:          0.43kb
	Compressed size:   0.28kb
	Compression ratio: 33.95%
Compressed /assets/AboutView-CEFj1iWj.js:
	Raw size:          0.23kb
	Compressed size:   0.20kb
	Compression ratio: 12.72%
Compressed /assets/AboutView-C6Dx7pxG.css:
	Raw size:          0.09kb
	Compressed size:   0.10kb
	Compression ratio: -20.00%
Compressed /assets/index-DCdgdx_-.js:
	Raw size:          95.77kb
	Compressed size:   37.42kb
	Compression ratio: 60.93%
Compressed /assets/index-D6pr4OYR.css:
	Raw size:          4.21kb
	Compressed size:   1.30kb
	Compression ratio: 68.98%
granborg@boden spa-to-cpp %
```

The script generates two files: webui.h and webui.cpp. The files exist in data as byte arrays, which can be served by iterating through the vector of file manifests.

## Integration

You can obtain a list of FileManifest objects from webui.h by calling

```
#include "webui.h"

std::vector<FileManifest*> file_manifests;
getFileManifests(file_manifests);
```

Each FileManifest contains a route, a pointer to the file bytes, and a length. All you need to do is serve these files in a C++ webserver, using a Content-Encoding=GZip header.

```
/* THIS FILE WAS GENERATED BY A SCRIPT! DO NOT EDIT! */
#ifndef WEB_UI
#define WEB_UI
#include <cstdint>
#include <vector>

class FileManifest {
	public:
		std::string route;
		uint8_t* bytes;
		size_t bytes_len;
};

#ifdef __cplusplus
extern "C" {
#endif

void getFileManifests(std::vector<FileManifest*> &file_manifests);

#ifdef __cplusplus
}
#endif

#endif
```

Here is an example of how you can add server routes to an ESPAsyncWebserver on the ESP32 embedded platform.

```
#include <Arduino.h>
#include <AsyncTCP.h>
#include <ESPAsyncWebServer.h>
#include <vector>
#include <string>
#include "webui.h"

String getContentType(std::string const &route)
{
    String contentType;

    if (route == "index.html")
        contentType = "text/html; charset=UTF-8";
    else if (endsWith(route, ".css"))
        contentType = "text/css; charset=UTF-8";
    else if (endsWith(route, ".js"))
        contentType = "application/javascript; charset=UTF-8";
    else if (endsWith(route, ".ico"))
        contentType = "image/x-icon";
    else if (endsWith(route, ".svg"))
        contentType = "image/svg+xml";
    else if (endsWith(route, ".png"))
        contentType = "image/png";
    else
        contentType = "text/plain; charset=UTF-8";

    return contentType;
}

void addRoutesFromFileManifests(AsyncWebServer &server)
{
    std::vector<FileManifest *> file_manifests;
    getFileManifests(file_manifests);

    for (FileManifest *f : file_manifests)
    {
        String contentType = getContentType(f->route);
        String route("/");
        if (f->route != "index.html")
        {
            route += f->route.c_str();
        }

        server.on(
            route.c_str(),
            HTTP_GET,
            [f, contentType](AsyncWebServerRequest *request)
            {
                AsyncWebServerResponse *response = request->beginResponse_P(200, contentType, f->bytes, f->bytes_len);
                response->addHeader("Content-Encoding", "gzip");
                response->addHeader("Cache-Control", "max-age=31536000");
                return request->send(response);
            });
    }
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

Copyright 2024 Brett Granborg

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
