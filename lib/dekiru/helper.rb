module Dekiru
  module Helper
    def menu_link_to(name = nil, options = nil, html_options = nil, &block)
      args = [name, options, html_options]
      html_options, options, name = options, name, block if block_given?

      classes = html_options.try(:delete, :li_class).try(:split, ' ') || []
      classes << 'active' if current_page?(options)

      obj = [options].flatten.last
      if obj.is_a?(ActiveRecord::Base)
        content_tag_for(:li, obj, :class => classes.join(' ')) do
          link_to name, options, html_options, &block
        end
      else
        content_tag(:li, :class => classes.join(' ')) do
          link_to *args, &block
        end
      end
    end

    def null_check_localization(*args)
      localize(*args) if args.try(:first).present?
    end
    alias nl null_check_localization

    def facebook_like(url = url_for(only_path: false), app_id = nil, width = 140)
      facebook_app_id = app_id || ENV['FACEBOOK_APP_ID']
      html = %Q(<iframe src="//www.facebook.com/plugins/like.php?href=#{u(url)}&amp;send=false&amp;layout=button_count&amp;width=140&amp;show_faces=false&amp;action=like&amp;colorscheme=light&amp;font=arial&amp;height=21&amp;appId=#{facebook_app_id}" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:#{width}px; height:21px;" allowTransparency="true"></iframe>)
      html.html_safe
    end

    def twitter_tweet
      html = <<-EOF
<a href="https://twitter.com/share" class="twitter-share-button">Tweet</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
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

    def google_analytics(code, options = {})
      if code.present? && ::Rails.env == 'production'
        multi_subdomain = if options[:domain]
                            "_gaq.push(['_setDomainName', '#{options[:domain]}']);"
                          end

        html = <<-EOF
<script type="text/javascript">
  var _gaq = _gaq || [];
    _gaq.push(['_setAccount', '#{code}']);
    #{multi_subdomain}
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
