function plotstate(da,fw)
% plot the true and estimated state
% input:
% da: data asismialtion data
% fw: true data
pvar = diag(da.P);
plot(1:fw.m,fw.xt.vec,'r',1:da.m,da.x.vec,'b',1:da.m,da.x.vec + 1.96*sqrt(pvar),'g',1:da.m,da.x.vec - 1.96*sqrt(pvar),'g')
hold on;
xi = [5 15 25 35 40 45 50 55 60 65 75 85 95];
plot(xi,fw.xt.vec(xi),'*')
legend('True','Estimated','95% interval');
end