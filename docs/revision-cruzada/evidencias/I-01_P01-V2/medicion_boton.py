import numpy as np
from PIL import Image
def lin(c):
    c=c/255.0; return np.where(c<=0.04045,c/12.92,((c+0.055)/1.055)**2.4)
def Lum(a): return lin(a)@np.array([0.2126,0.7152,0.0722])
def cr(bg): return 1.05/(Lum(bg)+0.05)
A=np.asarray(Image.open('btnA.png').convert('RGB')).astype(float); B=np.asarray(Image.open('btnB.png').convert('RGB')).astype(float)
d=np.abs(A-B).max(axis=2); ys,xs=np.where(d>8)
print('tamaño',A.shape,' extensión contenido x',xs.min(),'-',xs.max(),' y',ys.min(),'-',ys.max())
sub=(slice(ys.min(),ys.max()+1),slice(xs.min(),xs.max()+1)); As,Bs=A[sub],B[sub]
den=255-Bs; den[den<1]=1; alpha=np.clip(((As-Bs)/den).mean(axis=2),0,1)
for name,m in (('núcleo (cobertura>=0.9)',alpha>=0.9),('cobertura>0.3',alpha>0.3)):
    c=cr(Bs[m]); print('%-26s n=%5d  contraste mín %.2f  p5 %.2f  mediana %.2f'%(name,m.sum(),c.min(),np.percentile(c,5),np.median(c)))
# tramo del texto frente al icono
for a,b in ((0,50),(50,400)):
    m=(alpha>=0.9).copy(); m[:,:a]=False; m[:,b:]=False
    if m.sum(): print(' x rel %d-%d mín %.2f'%(a+xs.min(),b+xs.min(),cr(Bs[m]).min()))
print('umbral: texto grande (32 px semibold) 3:1 ; referencia texto normal 4.5:1')
