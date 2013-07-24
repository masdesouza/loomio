$(function() {

  var jqXHR;

 $('.direct-upload').each(function() {

    var form = $(this)

    $(this).fileupload({
      url: form.attr('action'),
      type: 'POST',
      autoUpload: true,
      dataType: 'xml', // This is really important as s3 gives us back the url of the file in a XML document
      add: function (event, data) {
        $.ajax({
          url: "/signed_urls",
          type: 'GET',
          dataType: 'json',
          data: {doc: {title: data.files[0].name}}, // send the file name to the server so it can generate the key param
          async: false,
          success: function(data) {
            // Now that we have our data, we update the form so it contains all
            // the needed data to sign the request
            form.find('input[name=key]').val(data.key);
            form.find('input[name=policy]').val(data.policy);
            form.find('input[name=signature]').val(data.signature);
          }
        })
        jqXHR = data.submit();
      },
      send: function(e, data) {
        var filename = data.files[0].name;
        $('#attachment-container .attachment-uploader .uploading-filename').html(filename)
        $('#attachment-container .attachment-uploader').show()
        $('#post-new-comment').attr('disabled', 'true')

        // $('.progress').fadeIn();
      },
      progress: function(e, data){
        // This is what makes everything really cool, thanks to that callback
        // you can now update the progress bar based on the upload progress
        var percent = Math.round((e.loaded / e.total) * 100)
        $('.bar').css('width', percent + '%')

        $('#attachment-container .attachment-uploader .close').click(function (e) {
          console.log('cancel method activated')
            jqXHR.abort();

        });
      },
      fail: function(e, data) {
        $('#post-new-comment').removeAttr('disabled')
        console.log('fail')
        console.log(e)
      },
      success: function(data) {
        // Here we get the file url on s3 in an xml doc
        var url = $(data).find('Location').text()
        var key = $(data).find('Key').text().split('/')
        var file_name = key[key.length-1];

        $('.attachment-uploader').hide();
        $('#attachment-container').append('<div>'+'<a href='+url+'>'+file_name+'</a></div>')

        $('#post-new-comment').removeAttr('disabled')
        // $.ajax({
        //   url: '/attachments',
        //   type: 'POST',
        //   dataType: 'text',
        //   data: url
        // }).done()

        // console.log(data)
        // console.log(file_name)
        // console.log(url)
        
        // $('#real_file_url').LastChild.html(file_name).attr('href', url)
        // $('#real_file_url').attr('href', url) // Update the real input in the other form
      },
      done: function (event, data) {
        $('.progress').fadeOut(300, function() {
          $('.bar').css('width', 0)
        })
      }
    })
  });
})
