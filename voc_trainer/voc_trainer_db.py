import pandas as pd
import os
#path=r"C:\Dokumente und Einstellungen\igor\Eigene Dateien\eclipse\Misc_Web\apps\vocab"
os.chdir("/home/igor/Documents/eclipse/Misc_Web/apps/voc_trainer")
path="./vocab/"
vocab_df=pd.DataFrame()
vocab_df=list()
for fl in os.listdir(path):
    print fl
    df=pd.read_csv(path+fl,sep="\t",names=["slov_word","pos","gen","germ_word"])
    df["les"]=fl[:-4]
    vocab_df.append(df)
    #vocab_df=pd.concat([vocab_df,pd.read_csv(path+"\\"+fl,sep="\t")],axis=1)
#print vocab_df

vocab_df=pd.concat(vocab_df,axis=0,ignore_index=True)
vocab_df["slov_word"]=vocab_df["slov_word"].str.replace(" $", "")
vocab_df=vocab_df.drop_duplicates(cols="slov_word")
vocab_df=vocab_df[-(vocab_df["pos"].isnull())]#.dropna()
#vocab_df["pos"]=vocab_df["pos"].fillna("nicht_klar")
les_dct={}
print(vocab_df["pos"].unique())
print(vocab_df["pos"].value_counts())


vocab_df["pos_freq"]=vocab_df["pos"].groupby(vocab_df["pos"]).transform(len)
#vocab_df.groupby(vocab_df["pos"]).transform(len)

#vocab_df.head(20)
pos_freq=vocab_df["pos"].value_counts()
df_lit5=vocab_df[vocab_df["pos_freq"]<5]

for les in vocab_df["les"].unique():
    subset=vocab_df[vocab_df["les"]==les]
    les_dct[les]=[]
    for row in subset.iterrows():
        #print dict(row)#.to_dict()
        les_dct[les].append(list(row[1]))

les_dct["les8"][1]

import json
les_js=json.dumps(les_dct)


with open("./voc_trainer_db.js","w+")  as f:
    f.write("voc_db=")
    f.write(les_js)


vocab_df["pos"].value_counts()
