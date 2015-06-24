# Imgur Upload Spike
This is a spike that uses RiotJS, Semantic UI (for CSS styling), the File API, FileReader API, FormData API, and XHR to upload an image to Imgur.

### Install

Install [NodeJS](https://nodejs.org/), then run this in the project folder root:

    npm install

### Run

Run the following command:

    npm start

It will set up a server at [http://localhost:8080](http://localhost:8080). Navigate to it to see the upload form.

### Dev Notes

Imgur exposes an [API](https://api.imgur.com/) that allows us to upload an image using XHR. A file is loaded in using the **File API** and the appropriate `<input>` tag. The **FileReader API** is then used to read the image directly on the browser and process it into a base64-encoded string that's set to an `<img>`'s src to give us a preview image.

Note that although `FileReader` reads in the file asynchronously, it will still freeze the UI for a second or two if you try to read in a particularly large file, like a 4K PNG that's around 10MB. Web workers may help with this delay, but that wasn't in the scope of this spike.

The image is then uploaded to Imgur using XHR with the **FormData API** to encode a form. We are sending the image as binary data; we can also base64 encode the image as well, but that will increase the file size significantly (around 33%).

The XHR upload will fire two events, `upload.onprogress`, which signifies the progress of the file upload, and `onload`, which tells us when the server has returned a response. Note that there is a slight delay of around 1-2 seconds after `upload.onprogress` returns 100%, but before `onload` is fired. This is because the image upload has been completed, but Imgur still needs some time to process it and send us a response.
