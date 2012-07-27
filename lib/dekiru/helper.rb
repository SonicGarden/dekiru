module Dekiru
  module Helper
    def menu_link_to(*args, &block)
      url_obj = block_given? ? args[0] : args[1]

      classes = []
      classes << "active" if current_page?(url_obj)

      obj = [url_obj].flatten.last
      if obj.is_a?(ActiveRecord::Base)
        content_tag_for(:li, obj, :class => classes.join(' ')) do
          link_to *args, &block
        end
      else
        content_tag(:li, :class => classes.join(' ')) do
          link_to *args, &block
        end
      end
    end

    def facebook_like(url = url_for(only_path: false))
      html = %Q(<iframe src="//www.facebook.com/plugins/like.php?href=#{u(url)}&amp;send=false&amp;layout=button_count&amp;width=140&amp;show_faces=false&amp;action=like&amp;colorscheme=light&amp;font=arial&amp;height=21&amp;appId=244243155670810" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:140px; height:21px;" allowTransparency="true"></iframe>)
      html.html_safe
    end

    def twitter_tweet
      html = <<-EOF
<a href="https://twitter.com/share" class="twitter-share-button">Tweet</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
EOF
      html.html_safe
    end

    def google_plus
      html = <<-EOF
<script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script>
<g:plusone size="medium"></g:plusone>
EOF
      html.html_safe
    end

    def google_analytics(code)
      if code.present? && ::Rails.env == "production"
        html = <<-EOF
<script type="text/javascript">
  var _gaq = _gaq || [];
    _gaq.push(['_setAccount', '#{code}']);
    _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
  </script>
EOF
        html.html_safe
      end
    end
  end
end
