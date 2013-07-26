$(function() {

  var jqXHR;
  var fileSize;

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
        console.log('send data', data);
        fileSize = (data.total >= 1048576) ? Math.round(data.total/104858)/10 + ' MB' : Math.round(data.total/1024) + ' kB';
        var filename = data.files[0].name;
        $('.uploading-filename').html(filename)
        $('.attachment-uploader').show()
        $('#post-new-comment').attr('disabled', 'true')

        // $('.progress').fadeIn();
      },
      progress: function(e, data){
        // This is what makes everything really cool, thanks to that callback
        // you can now update the progress bar based on the upload progress
        var percent = Math.round((e.loaded / e.total) * 100)
        $('.bar').css('width', percent + '%')

        $('.attachment-uploader .close').click(function (e) {
          console.log('cancel method activated')
          jqXHR.abort();
          $('.attachment-uploader').hide()
        });
      },
      fail: function(e, data) {
        $('#post-new-comment').removeAttr('disabled')
        console.log('fail')
        console.log(e)
      },
      success: function(data) {
        // Here we get the file url on s3 in an xml doc
        console.log('sucess data', data)
        var url = $(data).find('Location').text()
        var key = $(data).find('Key').text().split('/')
        var filename = key[key.length-1];


        $.ajax({
          url: "/attachments",
          type: 'POST',
          dataType: 'json',
          data: {filename: filename, location: url}, // send the file name to the server so it can generate the key param
          async: false,
          success: function(data) {
            // Now that we have our data, we update the form so it contains all
            // the needed data to sign the request
            console.log('successfully fired to controller')
            console.log(data)

            id = data.attachmentId
            $('#new-comment-form').append('<input type="hidden" id="comment-attachment-'+id+'" name="attachments[]" value="'+id+'">')
            $('.attachments').append('<div class="attachment-success">'+'<a href='+url+'>'+filename+'</a>'+' ('+fileSize+')<button id=cancel-attachment-'+id+' class="close">&times;</button></div>')

          },
          complete: function(data) {
            console.log('fired to controller')
          }
        })

        // $('.attachment-uploader').hide();



        $('#post-new-comment').removeAttr('disabled')

      },
      done: function (event, data) {
        $('.attachment-uploader').hide();
        $('.bar').css('width', 0 + '%');
      //   $('.progress').fadeOut(300, function() {
      //     $('.bar').css('width', 0)
      //   })
      }
    });
  });

  $(document).on('click', '.attachment-success .close', function (e) {
    // e.stopImmediatePropagation();
    // e.stopPropagation();
    // e.preventDefault();
    console.log('Working');
    var id = $(this).attr('id').split('-')[2];
    var selector = '#comment-attachment-' + id;
    $('#new-comment-form').find(selector).remove();

    var dog = $(this).parent()[0];
    console.log(dog);
    dog.remove();

  })

  $(document).on('click', '#upload-attachment', function (){
    $('input:file').trigger('click');
    return false;
  })

  // $('.attachment-success .close').click(function (e) {
  //   e.stopImmediatePropagation();
  //   e.stopPropagation();
  //   e.preventDefault();
  //   console.log('Working');
  //   var id = $(this).attr('id').split('-')[2];
  //   var selector = '#comment-attachment-' + id;
  //   $('#new-comment-form').find(selector).remove();

  //   var dog = $(this).parent()[0];
  //   console.log(dog);
  //   dog.remove();

  // })

});



