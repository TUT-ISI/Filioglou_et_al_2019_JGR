function [] = StereoMap_Data_subroutine(dset)

hFig = figure;
ha = tight_subplot(1,3,[.03 .06],[.15 .08],[.07 .03]);
axes(ha(1))

subplot(1,4,1); 
m_proj('stereographic','lat',90,'long',0,'radius',28);
m_coast('patch',[.8 .8 .8],'edgecolor','none');
m_grid('xtick',4,'tickdir','out','ytick',[70 80],'linest','-','fontsize',7);
hold on
m_scatter(dset(1).par.Geo(:,4),dset(1).par.Geo(:,3),1);
title('DJF');

subplot(1,4,2); 
m_proj('stereographic','lat',90,'long',0,'radius',28);
m_coast('patch',[.8 .8 .8],'edgecolor','none');
m_grid('xtick',4,'tickdir','out','ytick',[70 80],'linest','-','fontsize',7);
hold on
m_scatter(dset(3).par.Geo(:,4),dset(3).par.Geo(:,3),1)
title('MAM');

subplot(1,4,3); 
m_proj('stereographic','lat',90,'long',0,'radius',28);
m_coast('patch',[.8 .8 .8],'edgecolor','none');
m_grid('xtick',4,'tickdir','out','ytick',[70 80],'linest','-','fontsize',7);
hold on
m_scatter(dset(2).par.Geo(:,4),dset(2).par.Geo(:,3),1)
title('JJA');

subplot(1,4,4); 
m_proj('stereographic','lat',90,'long',0,'radius',28);
m_coast('patch',[.8 .8 .8],'edgecolor','none');
m_grid('xtick',4,'tickdir','out','ytick',[70 80],'linest','-','fontsize',6);
hold on
m_scatter(dset(4).par.Geo(:,4),dset(4).par.Geo(:,3),1)
title('SON');

set(hFig,'Position',[100, 200, 1149, 320]);
 
print(gcf,'-dpng','-r600','Fig3.png')

end