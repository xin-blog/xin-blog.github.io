  <script
  src="https://code.jquery.com/jquery-3.3.1.min.js"
  integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
  crossorigin="anonymous"></script>
{{ js('js/lightgallery.min.js') }}
{{ js('js/lg-zoom.min.js') }}
<script type='text/javascript'>
    $(document).ready(function() {
        $(".code").each(function() {
          var code = $(this);
          var text = "";
          var lines = code.find("span.line");
          lines.each(function (index, value){
              text = text + value.innerText + '\n';
          });

          lines.promise().done(function(){
            var node = code.closest("figure");
            var img = $('<img class="code-generate"/>');
            if(setImageUrl(text,img)){
              node.replaceWith(img);
            }
          });
        });

        $(".code").promise().done(function(){
          $(".article-content img").each(function(){
            var img = $(this);
            var src = img.attr("src");
            if(!src) return;
            if (src.match(".uml$") || src.match('.bpmn$')) {
              if(src.indexOf("http")!=0){
                var loc = window.location.pathname;
                var dir = loc.substring(0, loc.lastIndexOf('/')+1);
                if(src.indexOf("/")==0)
                  src = window.location.origin + src;
                else
                  src = window.location.origin + dir + src;
              }
              src = getImageUrl(src);
              img.attr("src",src);
              img.addClass("code-generate");
            }
          });

          $(document).ajaxStop(function () {
            $("#lightgallery").lightGallery(); 
            $(".article-content img").each(function(){
              console.log($(this).attr('src'))
              $(this).attr('data-src', $(this).attr('src')).lightGallery({
                  selector: 'this'
              })
            });       
          });

        });
    });
</script>


<style>
.code-generate{
    max-width:100%!important;
    max-height:100%!important;
}
</style>

<script type="text/javascript">
$(document).ready(function() {
  
});
</script>



