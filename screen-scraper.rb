require 'rubygems'
require 'mechanize'
require 'hpricot'

@order_url = "http://gengo.com/express/account/orders/"
@login_url = 'https://gengo.com/auth/login/'
@login_params = {'login_email'=> '<someone>', 'login_password' => '<somepassword>'}
@response = ''

begin
  @agent = Mechanize.new

  page = @agent.post(@login_url, @login_params)

  puts page.title

  page = @agent.get(@order_url)

  puts page.title

  next_url = ""
  next_url_nodes = page.search("span.pagination_next a")
  if next_url_nodes && !next_url_nodes.empty?
    next_url = next_url_nodes[0]['href']
  end
  puts "order_date,order_number,order_amount"
  while !next_url.empty?
    page.search("li.order").each do |order|
      order_date = order.at("span.account_list_date").text
      order_number = order.at("span.account_list_ref_id").text
      order_amount = order.at("span.account_list_price").text

      puts "#{order_date},#{order_number},#{order_amount}"
    end
    @order_url = next_url
    page = @agent.get(@order_url)
    next_url = ""
    next_url_nodes = page.search("span.pagination_next a")
    if next_url_nodes && !next_url_nodes.empty?
      next_url = next_url_nodes[0]['href']
    end
  end

  # HPricot RDoc: http://code.whytheluckystiff.net/hpricot/
  #doc = Hpricot(@response)
    
  # Retrive number of comments
  #puts (doc/"/html/body/div[3]/div/div/h2").inner_html
      
  # Pull out all quoted text (<blockquote> .... </blockquote>)
  #puts (doc/"blockquote/p").first.inner_html
	 
  # Pull out all other posted stories and date posted
  #(doc/"/html/body/div[4]/div/div[2]/ul/li/a/span").each do |article|
  #   puts "#{article.inner_html} :: #{article.next_node.to_s}"
  #end
    
rescue Exception => e
    puts e.message
    puts e.backtrace
end
