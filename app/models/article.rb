class Article < ApplicationRecord
    require 'rss'
    require 'open-uri' 
    has_many :like

    def get_news
    articles = []
       
    url = "https://g1.globo.com/rss/g1/"

    URI.open(url) do |rss|
        feed = RSS::Parser.parse(rss)

        (0..39).each do |news|
            dados = feed.items[news].description
            if dados.include?("https")
                img = dados.slice(0..dados.rindex("   ").to_i).slice(dados.index("https")..dados.rindex(" /><br />").to_i-2)
                dadosBruto = dados.slice(dados.rindex("   ").to_i..dados.size)
                # puts dadosBruto
                dadosBruto[dadosBruto.index("\n").to_i] = " - "
                text = dadosBruto.slice(dadosBruto.index(" - ").to_i..dadosBruto.size)
                subText = dadosBruto.slice(0..(dadosBruto.index(" - ").to_i + text.index("\n").to_i )).to_s
                subTitulo,legendaImg = subText.slice(0..subText.rindex('.').to_i ).to_s,subText.slice((subText.rindex('.').to_i + 1)..subText.size).to_s
                texto = dadosBruto.slice((dadosBruto.index(" - ").to_i + text.index("\n").to_i+1..dadosBruto.size))
                textoFinal = texto.slice(0..texto.rindex('.').to_i)
                # puts feed.items[news].title.to_s, subTitulo, img, legendaImg, textoFinal
                articles.push([feed.items[news].title.to_s, subTitulo, img, legendaImg, textoFinal])
            else
                textoFinal = dados.slice(0..dados.rindex('.').to_i)
                # puts feed.items[news].title.to_s, subTitulo, img, legendaImg, textoFinal
                articles.push([feed.items[news].title.to_s, "", "", "", textoFinal])
            end    
        end    

    end
        return articles
    end 

    def remove_stop_words
        text = Article.find_by_id(self.id).paragraph
        stopwords = [' de ', ' a ', ' o ', ' e  ', 'A ', 'O ', 'E  ', 'As ', 'Os ',  'É  ',' que ', ' do ', ' da ', ' em ',
        ' um ', ' para ', ' a  ', ' com ', ' não ', ' uma ', ' os ', ' no ', ' se ', 
        ' na ', ' por ', ' mais ', ' as ', ' dos ', ' como ', ' mas ', ' foi ', 
        ' ao ', ' ele ', ' das ', ' tem ', 'à ', ' seu ', ' sua ', ' ou ', ' ser ',
        ' quando ', ' muito ', ' há ', ' nos ', ' já ', ' está ', ' eu ', ' tambam ',
        ' só ', ' pelo ', ' pela ', ' até ', 'isso ', ' ela ', ' entre ', ' era ',
        ' depois ', ' sem ', ' mesmo ', ' aos ', ' ter ', ' seus ', 'quem ', ' nas ',
        ' me ', ' esse ', ' eles ', ' estão ', 'você ', ' tinha ', ' foram ', ' essa ',
        ' num ', ' nem ', ' suas ', ' meu ', 'às ', ' minha ', ' têm ', ' numa ', 
        ' pelos ', ' elas ', ' havia ', ' seja ', 'qual ', ' será ', ' nós ', 
        ' tenho ', ' lhe ', ' deles ', ' essas ', ' esses ', ' pelas ', ' este ',
        ' fosse ', ' dele ', ' tu ', ' te ', 'vocês ', 'vos ', ' lhes ', ' meus ',
        ' minhas ', ' teu ', ' tua ', ' teus ', ' tuas ', ' nosso ', ' nossa ',
        ' nossos ', ' nossas ', ' dela ', ' delas ', ' esta ', ' estes ', 
        ' estas ', ' aquele ', ' aquela ', ' aqueles ', ' aquelas ', 'isto ',
        ' aquilo ', ' estou ', ' está ', ' estamos ', ' estão ', ' estive ',
        ' esteve ', ' estivemos ', ' estiveram ', ' estava ', ' estávamos ',
        ' estavam ', ' estivera ', ' estivéramos ', ' esteja ', ' estejamos ',
        ' estejam ', ' estivesse ', ' estivéssemos ', ' estivessem ', ' estiver ',
        ' estivermos ', ' estiverem ', ' hei ', ' há ', ' havemos ', ' hão ', ' houve ',
        ' houvemos ', ' houveram ', ' houvera ', ' houvéramos ', ' haja ', ' hajamos ',
        ' hajam ', ' houvesse ', ' houvéssemos ', ' houvessem ', ' houver ', ' houvermos ',
        ' houverem ', ' houverei ', ' houverá ', ' houveremos ', ' houverão ', ' houveria ',
        ' houveríamos ', ' houveriam ', ' sou ', ' somos ', ' são ', ' era ', 'éramos ', ' eram ',
        ' fui ', ' foi ', ' fomos ', ' foram ', ' fora ', ' fôramos ', ' seja ', ' sejamos ',
        ' sejam ', ' fosse ', ' fôssemos ', ' fossem ', ' for ', ' formos ', ' forem ', ' serei ',
        ' será ', ' seremos ', ' serão ', ' seria ', ' seríamos ', ' seriam ', ' tenho ', ' tem ',
        ' temos ', ' tém ', ' tinha ', ' tínhamos ', ' tinham ', ' tive ', ' teve ', ' tivemos ',
        ' tiveram ', ' tivera ', ' tivéramos ', ' tenha ', ' tenhamos ', ' tenham ', ' tivesse ',
        ' tivéssemos ', ' tivessem ', ' tiver ', ' tivermos ', ' tiverem ', ' terei ', ' terá ',
        ' teremos ', ' terão ', ' teria ', ' teríamos ', ' teriam ']
        stopwords.each do |stop|    
            while text.include?(stop) do
                if stop === text.slice(text.index(stop)..(text.index(stop)+(stop.size-1)))
                    text.slice!(text.index(stop)..(text.index(stop)+(stop.size-2)))
                end    
            end
        end

        while text.include?("\n") do
            text[text.index("\n")] = " " 
        end 
        self.update("textReady": "#{text}")
    end  
    
    def similaridade (string1,string2)
        # string1 = "Suponha que esse seja texto que desejo comparar"
        # string2 = "Suponha que esse seja texto principal"
        # puts string1.class
        arraystr1 = string1.to_s.split(" ")
        norepeatstr1 = arraystr1.uniq
        countword1 = []

        # puts arraystr1
        # puts "\n\n"
        # puts norepeatstr1
        norepeatstr1.each_with_index do |word,i| 
            countword1[i] = 0   
            while arraystr1.include?(word) do
                countword1[i] += arraystr1.count(word)
                arraystr1.delete(word)
            end
        end 

        # puts "\n\n"
        # puts countword1
        #  puts "\n\n"

        arraystr2 = string2.to_s.split(" ")
        norepeatstr2 = arraystr2.uniq
        countword2 = []
        # puts arraystr2
        #  puts "\n\n"
        #  puts norepeatstr2
        norepeatstr2.each_with_index do |word,i| 
            countword2[i] = 0   
            while arraystr2.include?(word) do
                countword2[i] += arraystr2.count(word)
                arraystr2.delete(word)
            end
        end 
        # puts "\n\n"
        # puts countword2
        #  puts "\n\n"
        #  puts "\n\n"
        intsec = []
        norepeatstr1.each_with_index do |word,i|
            if norepeatstr2.include?(word) 
                intsec[i] = [countword1[i],countword2[norepeatstr2.index(word)]].min
            else
                intsec[i] = 0
            end
        end  

        count = 0
        count2 = 0
        intsec.each do |i|
            count+=i
        end  
        countword1.each do |i|
            count2+=i
        end 

        # puts count
        # puts count2
        # puts (count.to_f.fdiv(count2.to_f)*100).to_f
        return (count.to_f.fdiv(count2.to_f)*100).to_f
    end    

    def ranking
        lista = Article.all.sort
        puts lista
        @art = self
        @art.remove_stop_words
        rank = []
        (2..lista.size).each_with_index do |news,i|
            @article = lista[i]
            @article.remove_stop_words
            str1 = @art.textReady
            str2 = @article.textReady
            valor = @article.similaridade(str1,str2) 
            if valor != 100
                rank.append([valor,@article])
            end    
        end   
        return rank.sort.reverse
    end    
        
end
