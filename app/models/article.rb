class Article < ApplicationRecord
    require 'rss'
    require 'open-uri' 
    

    def get_news
        articles = []
       
    url = "https://g1.globo.com/rss/g1/brasil/"

    URI.open(url) do |rss|
        feed = RSS::Parser.parse(rss)

        (0..9).each do |news|
            dados = feed.items[news].description
            img = dados.slice(0..dados.rindex("   ")).slice(dados.index("https")..dados.rindex(" /><br />")-2)
            dadosBruto = dados.slice(dados.rindex("   ")..dados.size)
            dadosBruto[dadosBruto.index("\n")] = " - "
            text = dadosBruto.slice(dadosBruto.index(" - ")..dadosBruto.size)
            subText = dadosBruto.slice(0..(dadosBruto.index(" - ") + text.index(/[a-z]\s[A-Z]/) )).to_s
            subTitulo,legendaImg = subText.slice(0..subText.rindex('.')),subText.slice(subText.rindex('.')+1..subText.size)
            texto = dadosBruto.slice((dadosBruto.index(" - ") + text.index(/[a-z]\s[A-Z]/) )+1..dadosBruto.size) 
            textoFinal = texto.slice(0..texto.rindex('.'))
            # puts feed.items[news].title.to_s, subTitulo, img, legendaImg, textoFinal
            articles.push([feed.items[news].title.to_s, subTitulo, img, legendaImg, textoFinal])
        end    

    end
        return articles
    end 
end
