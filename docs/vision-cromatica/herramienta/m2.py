import numpy as np
from PIL import Image
from meas import L,cr
def med(im,b):
    a=np.asarray(im.crop(b)).reshape(-1,3); return tuple(int(x) for x in np.median(a,0))
for k in ['original','gris','protanopia','deuteranopia']:
    im=Image.open(f'P01_{k}.png').convert('RGB')
    comp=med(im,(215,326,235,356)); pend=med(im,(228,533,246,560)); card_c=med(im,(300,395,360,420)); card_p=med(im,(300,600,360,615))
    btn=med(im,(45,640,60,664)); ver=med(im,(50,640,60,664)); 
    print(k,'chip Completada(relleno)',comp,'| chip Pendiente(relleno)',pend,'ratio',round(cr(comp,pend),2),'| tarjeta compl vs pend',round(cr(card_c,card_p),2))
    # botón primario Completar (relleno oscuro) vs Ver detalle (relleno claro)
    c1=med(im,(60,650,80,664)); c2=med(im,(215,640,235,650)); print('   Completar relleno',c1,'Ver detalle relleno',c2,'ratio',round(cr(c1,c2),2))
    nb=med(im,(30,684,45,732)); print('   Nueva actividad relleno',nb,'vs fondo',med(im,(200,745,210,748)),round(cr(nb,med(im,(200,748,210,752))),2))
