import os 
import lxml.etree as et
os.getcwd()
os.chdir("/home/igor/Documents/eclipse/Misc_Web/apps/correcter/tabex_sl")
parser = et.HTMLParser()
html=et.parse("les5_noun_acc1.html",parser)

def remove_tds(cells,html):
    tags=html.iter("tr")
    for tag in tags:
        for i,td in enumerate(tag):
            print(i,td,cells)
            if i in cells:
                td.getparent().remove(td)
    print et.tostring(html)
remove_tds((0,1,2), html)
