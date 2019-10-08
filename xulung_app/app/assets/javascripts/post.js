$(function() {
  var mediaDropzone;
  mediaDropzone = new Dropzone("#photo-dropzone");
  return mediaDropzone.on("success", function(file, responseText) {
    var _this = this;
    appendContent(responseText.file_name.url, responseText.id);
    setTimeout(function(){
      $('#myModal').modal('hide');
      _this.removeAllFiles();
    },1000);
  });
});

var appendContent = function(imageUrl) {
  $("#photos").append('<div class="col-lg-4">' + 
    '<div class="thumbnail"><img src="' + imageUrl + '"/>' +
    '<div class="caption">' +
    '<input id="photos" name="photos[]" value="' + mediaId +'" type="checkbox">' + 
    '</div>' +
    '</div></div>');
  $("#delete").removeAttr('disabled');
  $("#no-photo").html("");
};