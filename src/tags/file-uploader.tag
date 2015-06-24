file-uploader
  h2 File Uploader

  form(name="uploadForm")
    input(type="file" name="image")

  .ui.segment
    img.ui.small.image(name="preview")

  button(name="uploadButton") Click Me To Upload

  .ui.basic.segment
    .ui.indicating.progress.hidden(name="progressBar")
      .ui.inverted.dimmer(name="dimmer")
        .ui.loader
      .bar
        .progress
      .label Uploading File

  h3.hidden(name="imgurLinkDiv")
    | Upload complete! Click here for file:
    div(name="imgurLink")

  script.
    global.fileUploader = this;

    // update the preview thumbnail when a new image is selected
    this.image.onchange = (e) => {
      let file = this.image.files[0];

      let reader = new FileReader();
      reader.onload = (e) => {
        this.preview.src = e.target.result;
      };

      reader.readAsDataURL(file);
    };

    // upload the image to imgur
    this.uploadButton.onclick = () => {
      let file = this.image.files[0];

      // set up the progress bar and show it
      global.progressBar = $(this.progressBar);
      $(this.progressBar).removeClass('hidden').progress('reset').progress('set').total(file.size);

      // do the file upload to imgur
      let request = new XMLHttpRequest();
      request.open('POST', 'https://api.imgur.com/3/image');
      request.setRequestHeader('Authorization', 'Client-ID 9e30fbfafe3d03f');

      // progress feedback, update the progress bar
      request.upload.onprogress = (event) => {
        console.log('progress', event.loaded, event.total, Math.floor(event.loaded / event.total * 100));
        $(this.progressBar).progress('set').progress(event.loaded);

        if ((event.loaded / event.total) >= 1) {
          $(this.progressBar).progress('complete');
          // show a spinner on the progress bar, it takes a few seconds for the
          // server to process the picture and return data to us
          $(this.dimmer).addClass('active');
        }
      };

      // file upload is done, hide progress bar and show link to image
      request.onload = () => {
        console.log('done', request);
        $(this.progressBar).progress('complete').addClass('hidden');
        $(this.dimmer).removeClass('active');
        let link = JSON.parse(request.response).data.link;
        $(this.imgurLink).html(`<a href="${link}">${link}</a>`);
        $(this.imgurLinkDiv).removeClass('hidden');
      };

      request.send(new FormData(this.uploadForm));
    };

  style(scoped).
    :scope { display: block }

    .progress {
      display: block;
      opacity: 1;
      transition: opacity 0.5s ease-out;
    }

    .hidden {
      opacity: 0;
    }
