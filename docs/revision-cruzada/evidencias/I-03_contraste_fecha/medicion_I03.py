import numpy as np, io
from PIL import Image
def lin(c):
    c=c/255.0; return np.where(c<=0.04045,c/12.92,((c+0.055)/1.055)**2.4)
def Lum(a): return lin(a)@np.array([0.2126,0.7152,0.0722])
def cr_white(bg): return 1.05/(Lum(bg)+0.05)
A=np.asarray(Image.open('hdA.png').convert('RGB')).astype(float); B=np.asarray(Image.open('hdB.png').convert('RGB')).astype(float)
print('tamaños',A.shape,B.shape)
# máscara de glifos de la fecha: diferencia A-B en la franja de la fecha
y0,y1=144,172
d=np.abs(A-B).max(axis=2)
reg=d[y0:y1,:]
ys,xs=np.where(reg>8); print('extensión de glifos: x',xs.min(),'-',xs.max(),' y',ys.min()+y0,'-',ys.max()+y0)
x0,x1=xs.min(),xs.max()
sub=(slice(y0,y1),slice(x0,x1+1))
Bs=B[sub]; As=A[sub]
den=(255-Bs); den[den<1]=1
alpha=np.clip(((As-Bs)/den).mean(axis=2),0,1)   # cobertura aprox. por píxel
core=alpha>=0.9
print('píxeles de glifo (alpha>=0.9):',int(core.sum()),' parcial (0.3-0.9):',int(((alpha>0.3)&(alpha<0.9)).sum()))
c_core=cr_white(Bs[core]); print('contraste mínimo bajo glifos núcleo: %.2f  (percentil 5: %.2f, mediana %.2f)'%(c_core.min(),np.percentile(c_core,5),np.median(c_core)))
cov=alpha>0.3; c_cov=cr_white(Bs[cov]); print('contraste mínimo bajo cualquier píxel con cobertura>0.3: %.2f'%c_cov.min())
cb=cr_white(Bs.reshape(-1,3)); print('contraste mínimo del fondo en todo el rectángulo de la fecha: %.2f ; máximo %.2f'%(cb.min(),cb.max()))
i=np.argmax(cr_white(Bs[core])*0-cr_white(Bs[core])); # posición del peor
yy,xx=np.where(core); k=np.argmin(c_core); print('peor píxel núcleo en x=%d y=%d bg=%s'%(xx[k]+x0,yy[k]+y0,Bs[core][k].astype(int)))
# por tramos horizontales
for a,b in [(16,70),(70,130),(130,190),(190,x1+1)]:
    m=core.copy(); m[:, :a-x0]=False; m[:, b-x0:]=False
    if m.sum(): print(' tramo x %3d-%3d : mín %.2f  (n=%d)'%(a,b,cr_white(Bs[m]).min(),m.sum()))
# por filas: efecto del halo inferior
for r in range(0,y1-y0,4):
    m=core.copy(); m[:r]=False; m[r+4:]=False
    if m.sum(): print(' fila y %d-%d : mín %.2f'%(y0+r,y0+r+3,cr_white(Bs[m]).min()))
# analítico: sólo degradado
def grad(x):
    t=x/390; st=[(0,(12,127,158)),(.55,(47,111,196)),(1,(122,91,224))]
    for (p0,c0),(p1,c1) in zip(st,st[1:]):
        if p0<=t<=p1:
            u=(t-p0)/(p1-p0); return np.array([c0[i]+(c1[i]-c0[i])*u for i in range(3)])
for x in (16,100,200,263,274): g=grad(x); print('degradado puro x=%d  rgb=%s  contraste=%.2f'%(x,g.round().astype(int),cr_white(g)))
# fondo medido sin texto en la fila central de la fecha, sin halo
print('B en (x=20,y=157):',B[157,20].astype(int),'cr=%.2f'%cr_white(B[157,20]))
# método del Grupo F sobre JPEG
for q in (95,85,75,60):
    buf=io.BytesIO(); Image.fromarray(A.astype(np.uint8)).save(buf,'JPEG',quality=q); J=np.asarray(Image.open(buf)).astype(float)
    Js=J[sub]; bgm=np.median(Js.reshape(-1,3),axis=0)
    dd=np.abs(Lum(Js.reshape(-1,3))-Lum(bgm)); coreJ=Js.reshape(-1,3)[dd>=0.8*dd.max()]; fg=np.median(coreJ,axis=0)
    h,l=max(Lum(fg),Lum(bgm)),min(Lum(fg),Lum(bgm)); print('método JPEG q=%d: fg=%s bg=%s ratio=%.2f'%(q,fg.astype(int),bgm.astype(int),(h+.05)/(l+.05)))
