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
