WorkingDir='/home/helios/a/tsizyuk/Work_1/diff_project/Variant_01/';
FileMask = '0***.DAT';

cd( WorkingDir );
GivenFiles = dir( FileMask );   
NFiles = size( GivenFiles, 1 ); 

ImageFile = FileMask; % Imagefile - file name of the image, extension is changed
ImageFile( 6 : 8 ) = 'bmp';
ZDim=200;
TimeSec=0.;

for NFile =  1: NFiles
DataFile = GivenFiles( NFile ).name( 1 : 8 );
ImageFile( 1 : 5 ) = DataFile( 1 : 5 );
[DataFileUnit1, Message] = fopen( DataFile, 'rt' );
       
[A,count] = fscanf( DataFileUnit1,'%11e%11e',[2,ZDim]);
fclose(DataFileUnit1);

A(1,1:ZDim)=A(1,1:ZDim)*1.e7;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure( 'Position', [100 100 1100 800], 'InvertHardcopy', 'off', 'Color', 'w'); 
a = 0.13; b = 0.13; 
c = 0.78; d = 0.78;

han=axes( 'Units', 'normalized', 'Position', [a b c d] , 'XLim',[0.,200.], 'YLim',[0.,1.e21],...
    'LineWidth',1.5, 'FontName', 'Times', 'FontSize', 16, 'FontWeight', 'bold', 'Layer', 'top','TickDir','out','box','on');
grid on;
hold on;

xlabel( 'Depth, \itnm', 'FontName', 'Times', 'FontWeight', 'bold', 'FontSize', 24);
ylabel( 'D concentration, \itcm^-^3', 'FontName', 'Times', 'FontWeight', 'bold', 'FontSize', 24); 
  
plot(A(1,1:ZDim),A(2,1:ZDim),'-g','LineWidth',3.5);
hold on;

text( 0.9, 0.9, sprintf( '%3.1f s', TimeSec ), 'Units', 'normalized', 'HorizontalAlignment', 'center', ...
    'FontName', 'Times', 'FontSize', 22, 'FontWeight', 'bold', 'Color', 'k' );

print ('-dbmp', ImageFile);

close(gcf);
TimeSec=TimeSec+1.e3;
end
return