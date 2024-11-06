# Photo & Video MetaData
Scripts for managing meta data for video files

## Requirements
* Install Media Info CLI from https://mediaarea.net/en/MediaInfo
* Install Exiftool from https://exiftool.org

## Exiftool Command Line Arguments

### General Options
- `-q`: Quiet processing. Suppresses normal messages.
- `-q -q`: Extra quiet processing. Suppresses all messages.
- `-b`: Output data in binary format.
- `-api largefilesupport=1`: Enables support for large files.
- `-overwrite_original`: Overwrites the original file with the new metadata.

### Date and Time
- `-CreateDate`: Extracts the creation date of the file.
- `-DateTimeOriginal`: Extracts the original date and time when the file was created.
- `-SubSecCreateDate`: Extracts the creation date with sub-second precision.
- `-xmp:DateTimeOriginal`: Sets the XMP original date and time tag.
- `-xmp:ShotDate`: Sets the XMP shot date tag.

### Camera Information
- `-Model`: Extracts the camera model used to create the file.
- `-Make`: Extracts the camera make used to create the file.
- `-xmp:Model`: Sets the XMP model tag.
- `-xmp:Make`: Sets the XMP make tag.

### GPS Information
- `-GPSCoordinates`: Extracts the GPS coordinates.
- `-UserData:GPSCoordinates`: Sets the GPS coordinates in the user data.
- `-xmp:LocationShownCountryCode`: Sets the XMP location shown country code tag.
- `-xmp:LocationCreatedCountryCode`: Sets the XMP location created country code tag.
- `-xmp:LocationShownCountryName`: Sets the XMP location shown country name tag.
- `-xmp:LocationCreatedCountryName`: Sets the XMP location created country name tag.
- `-xmp:LocationShownProvinceState`: Sets the XMP location shown province/state tag.
- `-xmp:LocationCreatedProvinceState`: Sets the XMP location created province/state tag.
- `-xmp:LocationShownCity`: Sets the XMP location shown city tag.
- `-xmp:LocationCreatedCity`: Sets the XMP location created city tag.
- `-xmp:LocationShownSublocation`: Sets the XMP location shown sublocation tag.
- `-xmp:LocationCreatedSublocation`: Sets the XMP location created sublocation tag.

### Descriptive Information
- `-xmp:ImageDescription`: Sets the XMP image description tag.
- `-xmp:Title`: Sets the XMP title tag.
- `-xmp:Headline`: Sets the XMP headline tag.
- `-xmp:Description`: Sets the XMP description tag.
- `-xmp:Creator`: Sets the XMP creator tag.
- `-xmp:Marked`: Sets the XMP marked tag.
- `-xmp:Rights`: Sets the XMP rights tag.
- `-Rights`: Extracts the copyright information.
- `-Headline`: Extracts the headline information.
- `-Title`: Extracts the title information.
- `-Description`: Extracts the description information.
- `-CountryCode`: Extracts the country code information.
- `-Country`: Extracts the country information.
- `-State`: Extracts the state information.
- `-City`: Extracts the city information.
- `-Location`: Extracts the location information.
- `-Creator`: Extracts the creator information.

### Video Information
- `-xmp:VideoFrameSizeH`: Sets the XMP video frame size height tag.
- `-xmp:VideoFrameSizeW`: Sets the XMP video frame size width tag.
- `-xmp:VideoFrameRate`: Sets the XMP video frame rate tag.
- `-xmp:VideoCompressor`: Sets the XMP video compressor tag.
- `-xmp:VideoFrameSizeUnit`: Sets the XMP video frame size unit tag.

### Miscellaneous
- `-xmp:DigitalSourceType`: Sets the XMP digital source type tag.

