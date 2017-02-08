require 'faraday'
require 'redcarpet'
require 'oga'
require 'yaml'
require 'pry'

module ListFetcher
  AWESOME_LIST_URL = 'https://rawgit.com/sindresorhus/awesome/master/readme.md'

  def self.save_lists_to_data_file
    yaml = awesome_lists.to_yaml
    File.open('data/lists.yml', 'w+') do |f|
      f.write(yaml)
    end
  end

  def self.awesome_lists
    markdown = fetch_list_content_raw(AWESOME_LIST_URL)
    html = to_html(markdown)
    oga = Oga.parse_html(html)
    oga.css('a').select do |link_node|
      url = link_node.attr('href').value
      URI.parse(url).host && url.include?('github.com')
    end.map do |link_node|
      { name: link_node.text,
        slug: link_node.text.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, ''),
        repo_path: URI.parse(link_node.attr('href').value).path[1..-1],
        url: link_node.attr('href').value }
    end
  end

  # private

  def self.fetch_list_content_raw(url)
    conn(url).get.body
  end

  def self.to_html(markdown)
    @@parser ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    @@parser.render(markdown)
  end

  def self.conn(url)
    @@conn ||= Faraday.new(url: url) do |faraday|
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end
end

