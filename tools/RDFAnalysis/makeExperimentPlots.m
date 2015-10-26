function makeExperimentPlots

%make for ROI_e02

l = length(rdf);
l = 430;
factor = 0.645;

factorlength = round(factor*l);
%factorlength =

plot(1:factor:(factorlength), rdf(1, 1:l), 'g')

hold on

plot(1:factor:(factorlength), rdf(50, 1:l), 'c')

plot(1:factor:(factorlength), rdf(58, 1:l), 'b')

plot(1:factor:(factorlength), rdf(60, 1:l), 'm')

plot(1:factor:(factorlength), rdf(74, 1:l), 'r')

legend('23 hours p.i.', '85.5 hours p.i.', '95.5 hours p.i.', '98 hours p.i', ...
       '115.5  hours p.i.')
xlabel('um')
ylabel('average intensity')



plot(1:factor:(factorlength+0.9), rdf(1, 1:l), 'g')
hold on

plot(1:factor:(factorlength+0.9), rdf(50, 1:l), 'c')

plot(1:factor:(factorlength+0.9), rdf(58, 1:l), 'b')

plot(1:factor:(factorlength+0.9), rdf(60, 1:l), 'm')

plot(1:factor:(factorlength+0.9), rdf(74, 1:l), 'r')

legend('23 hours p.i.', '85.5 hours p.i.', '95.5 hours p.i.', '98 hours p.i', ...
       '115.5  hours p.i.')
xlabel('um')
ylabel('average intensity')


x = 1:l;
x = x*factor;

plot(x, rdf(1, 1:l), 'g')
hold on

plot(x, rdf(50, 1:l), 'c')

plot(x, rdf(58, 1:l), 'b')

plot(x, rdf(60, 1:l), 'm')

plot(x, rdf(74, 1:l), 'r')

legend('23 hours p.i.', '85.5 hours p.i.', '95.5 hours p.i.', '98 hours p.i', ...
       '115.5  hours p.i.')
xlabel('um')
ylabel('average intensity')



plot(1:l, rdf(1, 1:l), 'g')

hold on

plot(1:l, rdf(50, 1:l), 'c')

plot(1:l, rdf(58, 1:l), 'b')

plot(1:l, rdf(60, 1:l), 'm')

plot(1:l, rdf(74, 1:l), 'r')

legend('23 hours p.i.', '85.5 hours p.i.', '95.5 hours p.i.', '98 hours p.i', ...
       '115.5  hours p.i.', 'Location', 'NorthEast')


plot(x, rdf(1, 1:l), 'g')

hold on

plot(x, rdf(36, 1:l), 'k')

plot(x, rdf(50, 1:l), 'c')

plot(x, rdf(58, 1:l), 'b')

plot(x, rdf(60, 1:l), 'm')

plot(x, rdf(74, 1:l), 'r')

legend('23 hours p.i.', '85.5 hours p.i.', '95.5 hours p.i.', '98 hours p.i', ...
       '115.5  hours p.i.', 'Location', 'NorthEast')
xlabel('um')
ylabel('average intensity')


axis([0 250 0 0.06])
axis on
scale = 0.02617;

plot(x, RDFs(1, 1:l)*0.026177171, 'g')

hold on

plot(x, RDFs(2, 1:l)*0.026177171, 'k')

plot(x, RDFs(3, 1:l)*0.026177171, 'c')

plot(x, RDFs(4, 1:l)*0.026177171, 'b')

plot(x, RDFs(5, 1:l)*0.026177171, 'm')

plot(x, RDFs(6, 1:l)*0.026177171, 'r')

legend('23 hours p.i.', '86 hours p.i.', '100 hours p.i.', '120 hours p.i', ...
       '200 hours p.i.',  '215 hours p.i.', 'Location', 'NorthEast')
xlabel('um')
ylabel('average intensity')






end