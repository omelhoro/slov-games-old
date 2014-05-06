import re
import json

with open("mover_texts.txt") as f:
    text_db=f.read().decode("utf8")

def to_html(x):
    case=x.group(1)
    word=x.group(2)
    return "<span class='noun'data-case='{case}' >{word}</span>".format(case=case,word=word)

#text_db=text_db.replace("\n\n","")
#text_db=text_db.replace("\n","")
#text_db=re.sub(r"\\(\w{3})\{(.+?)\}",to_html,text_db)
text_db=re.sub(r"\\footnote\{.+?\}","",text_db)

parts=text_db.split("\subsection*")[1:]
#print parts

text_dct={}
for part in parts:
    header=part[0:part.index("\n")]
    rest_part=part[part.index("\n"):]
    text_dct[header[1:-1]]=[re.sub(r"\\(\w{3})\{(.+?)\}", to_html,par.replace("\n","")) for par in rest_part.split("\r\n\r\n") if par]
    print(rest_part.split("\r\n\r\n"))
    print(len(text_dct[header[1:-1]])) 

print text_dct
text_json=json.dumps(text_dct)
with open("case_text_txt.js","w+") as f:
    f.write("txt_db=")
    f.write(text_json)