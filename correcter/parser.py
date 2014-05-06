import re
import json
import lxml.etree as et
import os 
#os.getcwd()
#os.chdir("/home/igor/Documents/eclipse/Misc_Web/apps/correcter/tabex_sl")

#remove_tds((0,1,2), html)

def make_lst(s):
    itms=s.group(0).replace("lst:","").split(",")
    lst="<ul>"
    for itm in itms:
        lst=lst+"<li>"+itm+"</li>"
    return lst +"</ul>\n"

def insert_html(x):
    
    def remove_tds(cells,source):
        parser = et.HTMLParser(encoding="utf8")
        html=et.parse(source,parser)
        tags=html.iter("tr")
        for tag in tags:
            for i,td in enumerate(tag):
                if i in cells:
                    td.getparent().remove(td)
        html_str=et.tostring(html,encoding="utf8")#.encode("utf8")
        print html_str
        return html_str
        
    def convert_html(x):
        pat=x.group(0)
        if "fail.gif"in pat:
            lbord=pat.rfind(">")+1
            rbord=pat.rfind("<")
            wrap_span=lambda ln: "<span>"+ln+"<button class='corrector'>?</button></span>"
            sol=pat[lbord:rbord].strip().replace("  "," ").replace(" ","_")
            sol=" _"+sol+" "
            sol_html="<td>"+wrap_span(sol)+"</td"
            #print "<td>"+wrap_span(sol)+"</td",pat
            return  sol_html
        else:
            print pat
            return pat
    
    flnm=x.group(0).replace("File:","").strip()
    fltr=flnm.find("|")
    if fltr!=-1:
        fltr_tp=tuple([int(d) for d in flnm[:fltr]])
        flnm=flnm[fltr+1:]
    else:
        fltr_tp=(-1,)
    pth="tabex_sl/{}".format(flnm)
    html=remove_tds(fltr_tp, pth)
    #with open(pth) as f:
    #    html=f.read()
    html=html.replace("\n","")
    html=re.sub("\<td.*?\>(.+?)(</td)",convert_html,html)
    return "<table>"+html+"</table>"

def make_audio(x):
    au=x.group(0)
    au_str="<img width=15px height=15px src='static/play.png'/> "
    return au_str

def make_tsk(x):
    tsk=x.group(0).replace("tsk_exp:","").split("|")
    tsk_de=tsk[0]
    tsk_sl=tsk[1]
    tsk_str="|<p><span id='tsk_de'>{0}</span><span id='tsk_sl'>{1}</span></p>".format(tsk_de,tsk_sl)
    return tsk_str
    
with open("exercises.txt") as f:
    #excs=[s.split("__") for s in f.read().split("s_exercises,") if s]
    excs=f.read()
    excs=re.sub(" au_(.+?)\s",make_audio,excs)
    excs=re.sub("tsk_exp:(.+?)\n",make_tsk,excs)
    excs=re.sub("lst:(.+?)\n",make_lst,excs)
    excs=re.sub("File:(.+)?\n",insert_html,excs)
    excs=re.sub(" _(?P<na>.+?)\s"," <input data-sol='\g<na>'/>",excs)
    excs=[[sec.split("__") for sec in s.split("Topic:")] for s in excs.split("s_exercises,") if s]




def make_input(exc):
    #exc=re.sub(" _(?P<na>.+?)\s","<input data-sol='\g<na>'/>",exc)
    exc=exc.split("\n")
    wrap_span=lambda ln: "<span>"+ln+"<button class='corrector'>?</button></span>" if "data-sol" in ln and "button" not in ln else ln
    exc="".join(wrap_span(ln) for ln in exc if ln)
    return exc




ex= {e[0][0].strip():{ky[0].strip():make_input(ky[1]) for ky in e[1:]} for e in excs }



#ex={exc[0].split("\n")[0]:make_input(exc[1]) for exc in excs}
js=json.dumps(ex)
print js  
with open("correcter_db.js","w+") as f:
    f.write("taskDb=")
    f.write(js)

