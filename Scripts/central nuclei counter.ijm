waitForUser("choose file location of primary classifier")
prim_class_loc = getDirectory("choose file location of primary classifier");
waitForUser("choose file location of iterative classifier")
it_class_loc = getDirectory("choose file location of iterative classifier");
waitForUser("choose place to save single channel images")
chnl_img = getDirectory("choose place to save single channel images");
waitForUser("choose place to save convolved images")
cnv = getDirectory("choose place to save convolved images");
waitForUser("choose place to save segmented images")
prm__seg = getDirectory("choose place to save segmented images")
waitForUser("choose place to save iteratively segmented images")
it__seg = getDirectory("choose place to save iteratively segmented images");
waitForUser("choose place to save fused images")
fused_img = getDirectory("choose place to save fused images images");
waitForUser("choose place to save fiber type and morphometry data")
dat_loc = getDirectory("choose place to save fiber type and morphometry data");

Dialog.create("Morphometric Gates");00000000
Dialog.addMessage ("Morphometric Gates");

Dialog.addNumber("Min Area", 300);
Dialog.addNumber("Max Area", 13000);

Dialog.addMessage ("\n");
Dialog.addNumber("Min Circularity", 0.5);
Dialog.addNumber("Max Circularity", 1);

Dialog.addMessage ("\n");
Dialog.addNumber("Min solidity", 0.75);
Dialog.addNumber("Max solidity", 1);

Dialog.addMessage ("\n");
Dialog.addNumber("Min perimeter", 0);
Dialog.addNumber("Max perimeter", 1000);

Dialog.addMessage ("\n");
Dialog.addNumber("Min min ferret", 20);
Dialog.addNumber("Max min ferret", 10000);

Dialog.addMessage ("\n");
Dialog.addNumber("Min ferret AR", 0);
Dialog.addNumber("Max ferret AR", 8);

Dialog.addMessage ("\n");
Dialog.addNumber("Min roundess", 0.2);
Dialog.addNumber("Max roundess", 1);


Dialog.show();

minAr = Dialog.getNumber();
maxAr = Dialog.getNumber();

minCir = Dialog.getNumber(); 
maxCir = Dialog.getNumber();

minSol = Dialog.getNumber(); 
maxSol = Dialog.getNumber();

minPer = Dialog.getNumber(); 
maxPer = Dialog.getNumber();

minMinFer = Dialog.getNumber(); 
maxMinFer = Dialog.getNumber();

minFAR = Dialog.getNumber(); 
maxFAR = Dialog.getNumber();

minRnd = Dialog.getNumber(); 
maxRnd = Dialog.getNumber();

Dialog.create("ROI Expansion");
Dialog.addMessage ("ROI Expansion");

Dialog.addNumber("ROI expansion factor", 4);

Dialog.show();

elrg = Dialog.getNumber();

Dialog.create("Set scale");
Dialog.addMessage ("set scale for your image as pixels:microns");

Dialog.addNumber("pixels", 1);
Dialog.addNumber("microns", 1.1);

Dialog.show();

pix = Dialog.getNumber();
mic = Dialog.getNumber();


Dialog.create("Hyperstack Order");
Dialog.addMessage ("Put the number corresponding to the position (from left to right) of the channel in the hyperstack (e.g. if it is in the second position, put 2)");

Dialog.addNumber("Membrane", 1);
Dialog.addNumber("DAPI", 2);

Dialog.show();

membrane = Dialog.getNumber();
DAPI = Dialog.getNumber();

myoT = getTitle()
myoD = getDirectory("image")
saveAs("Tiff", myoD + myoT)
myoTN = getTitle()

rename("Myosoft-1 one.tif")  

selectWindow("Myosoft-1 one.tif");
run("Duplicate...", "duplicate channels="+membrane+"");
run("Color Balance...");
run("Enhance Contrast", "saturated=0.35");
run("Apply LUT");
saveAs("Tiff", chnl_img + "Myosoft-1 membrane");


run("Enhance Contrast", "saturated=1");
run("8-bit");
run("8-bit");
run("Invert");
run("Convolve...", "text1=[-1.0 -1.0 -1.0 -1.0 -1.0\n-1.0 -1.0 -1.0 -1.0 0\n-1.0 -1.0 24.0 -1.0 -1.0\n-1.0 -1.0 -1.0 -1.0 -1.0\n-1.0 -1.0 -1.0 -1.0 0] normalize");


n = getNumber("How many divisions (e.g., 2 means quarters)?", 4); 
id = getImageID(); 
title = getTitle(); 
getLocationAndSize(locX, locY, sizeW, sizeH); 
width = getWidth(); 
height = getHeight(); 
tileWidth = width / n; 
tileHeight = height / n; 
for (y = 0; y < n; y++) { 
offsetY = y * height / n; 
 for (x = 0; x < n; x++) { 
offsetX = x * width / n; 
selectImage(id); 
 call("ij.gui.ImageWindow.setNextLocation", locX + offsetX, locY + offsetY); 
tileTitle = title + " [" + x + "," + y + "]"; 
 run("Duplicate...", "title=" + tileTitle); 
makeRectangle(offsetX, offsetY, tileWidth, tileHeight); 
 run("Crop"); 
}  
} 

if (n==1) {
	selectWindow("Myosoft-1 membrane.tif"); 
	close();
	selectWindow("Myosoft-1 one.tif"); 
	close();
	selectWindow("Myosoft-1"); 
	saveAs(cnv + "Myosoft-1");
	close();

}

if (n==2) {
	selectWindow("Myosoft-1 membrane.tif"); 
	close();
	selectWindow("Myosoft-1 one.tif"); 
	close();
	selectWindow("Myosoft-1"); 
	saveAs(cnv + "Myosoft-1");
	close();
		       
	for(i=0; i<3; i++)
		  if (isOpen("Myosoft-1")) { 
		      selectWindow("Myosoft-1"); 
		      run("Duplicate...", "duplicate channels= 1");
		      selectWindow("Myosoft-1"); 
		      close();
		   } 
		 
	cnv_open=newArray(nImages); 
	for (i=0;i<nImages;i++) { 
		       selectImage(i+1); 
		       title = getTitle; 
		       print(title); 
		       cnv_open[i]=getImageID; 
		       saveAs("tiff", cnv+title);
		       
	}}

if (n==3) {
	selectWindow("Myosoft-1 membrane.tif"); 
	close();
	selectWindow("Myosoft-1 one.tif"); 
	close();
	selectWindow("Myosoft-1"); 
	saveAs(cnv + "Myosoft-1");
	close();
		       
	for(i=0; i<8; i++)
		  if (isOpen("Myosoft-1")) { 
		      selectWindow("Myosoft-1"); 
		      run("Duplicate...", "duplicate channels= 1");
		      selectWindow("Myosoft-1"); 
		      close();
		   } 
		 
	cnv_open=newArray(nImages); 
	for (i=0;i<nImages;i++) { 
		       selectImage(i+1); 
		       title = getTitle; 
		       print(title); 
		       cnv_open[i]=getImageID; 
		       saveAs("tiff", cnv+title);
		       
	}}

if (n==4) {
	selectWindow("Myosoft-1 membrane.tif"); 
	close();
	selectWindow("Myosoft-1 one.tif"); 
	close();
	selectWindow("Myosoft-1"); 
	saveAs(cnv + "Myosoft-1");
	close();
		       
	for(i=0; i<15; i++)
		  if (isOpen("Myosoft-1")) { 
		      selectWindow("Myosoft-1"); 
		      run("Duplicate...", "duplicate channels= 1");
		      selectWindow("Myosoft-1"); 
		      close();
		   } 
		 
	cnv_open=newArray(nImages); 
	for (i=0;i<nImages;i++) { 
		       selectImage(i+1); 
		       title = getTitle; 
		       print(title); 
		       cnv_open[i]=getImageID; 
		       saveAs("tiff", cnv+title);
		       
	}}
	        
if (n==5) {
	selectWindow("Myosoft-1 membrane.tif"); 
	close();
	selectWindow("Myosoft-1 one.tif"); 
	close();
	selectWindow("Myosoft-1"); 
	saveAs(cnv + "Myosoft-1");
	close();
		       
	for(i=0; i<24; i++)
		  if (isOpen("Myosoft-1")) { 
		      selectWindow("Myosoft-1"); 
		      run("Duplicate...", "duplicate channels= 1");
		      selectWindow("Myosoft-1"); 
		      close();
		   } 
		 
	cnv_open=newArray(nImages); 
	for (i=0;i<nImages;i++) { 
		       selectImage(i+1); 
		       title = getTitle; 
		       print(title); 
		       cnv_open[i]=getImageID; 
		       saveAs("tiff", cnv+title);
		       
	}}

run("Close All");

open(myoD+myoTN);
rename("Myosoft-1 one");  

run("Color Balance...");
run("Duplicate...", "duplicate channels="+DAPI+"");
run("Color Balance...");
run("Enhance Contrast", "saturated=0.35");
run("Apply LUT");
saveAs("Tiff", chnl_img + "Myosoft-1 DAPI");

run("Trainable Weka Segmentation");
wait(2000);
TWS=getTitle();

selectWindow(""+TWS+"");
call("trainableSegmentation.Weka_Segmentation.loadClassifier", prim_class_loc + "simple fiber outline classifier.model");
call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-1.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
selectWindow("Classification result");
run("Delete Slice");
saveAs("Tiff", prm__seg + "Myosoft-1");
close();
close();

if (n>=2) {
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-2.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-2");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-3.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-3");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-4.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-4");
	close();
	close();

}

if (n>=3) {

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-5.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-5");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-6.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-6");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-7.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-7");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-8.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-8");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-9.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-9");
	close();
	close();
}

if (n>=4) {

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-10.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-10");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-11.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "")
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-11");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-12.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-12");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-13.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-13");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-14.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-14");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-15.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-15");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-16.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-16");
	close();
	close();

}

if (n==5) {
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-17.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-17");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-18.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-18");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-19.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-19");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-20.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-20");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-21.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-21");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-22.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-22");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-23.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-23");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-24.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-24");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-25.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-25");
	close();
	close();
}

selectWindow(""+TWS+"");
call("trainableSegmentation.Weka_Segmentation.loadClassifier", it_class_loc + "iterative classifier  centronuceli.model");
call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-1.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
selectWindow("Classification result");
run("Delete Slice");
saveAs("Tiff", it__seg + "Myosoft-1");
close();
close();

if (n>=2) {

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-2.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-2");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-3.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-3"); 
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-4.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-4");
	close();
	close();
}

if (n>=3) {
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-5.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-5");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-6.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-6");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-7.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-7");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-8.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-8");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-9.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-9");
	close();
	close();
}

if (n>=4) {

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-10.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-10");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-11.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "")
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-11");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-12.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-12");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-13.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-13");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-14.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-14");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-15.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-15");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-16.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-16");
	close();
	close();

}

if (n==5) {
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-17.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-17");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-18.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-18");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-19.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-19");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-20.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-20");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-21.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-21");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-22.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-22");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-23.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-23");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-24.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-24");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-25.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-25");
	close();
	close();
}

run("Grid/Collection stitching", "type=[Grid: row-by-row] order=[Right & Down                ] grid_size_x="+n+" grid_size_y="+n+" tile_overlap=0 first_file_index_i=1 directory=["+it__seg+"] file_names=Myosoft-{i}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display] use");
selectWindow("Fused");
run("8-bit");
saveAs("Tiff", fused_img + myoT + "_segmented.tif");

run("Close All");

open(fused_img + myoT + "_segmented.tif"); 

run("Plots...", "width=530 height=300 font=12 draw draw_ticks minimum=-50 maximum=-50 interpolate sub-pixel");
run("Set Scale...", "distance="+mic+" known=1 pixel="+pix+" unit=micron"); 
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding shape feret's median redirect=None decimal=4");

run("Median...", "radius=3"); 
run("Gaussian Blur...", "sigma=2"); 
setAutoThreshold("MaxEntropy");
run("Create Mask");
run("Invert");

setForegroundColor(255,255,255);
drawRect(0, 0, getWidth(), getHeight());
run("Extended Particle Analyzer", "pixel area="+minAr+"-"+maxAr+" min_feret="+minMinFer+"-"+maxMinFer+" perimeter="+minPer+"-"+maxPer+" feret_ar="+minFAR+"-"+maxFAR+" circularity="+minCir+"-"+maxCir+" roundness="+minRnd+"-"+maxRnd+" solidity="+minSol+"-"+maxSol+" show=Outlines redirect=None keep=None display summarize add");


ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);

nbFibers=roiManager("count");
if (nbFibers > 0) {
		selectWindow("ROI Manager");
		for (i=0 ; i<nbFibers; i++) {
		    roiManager("select", i);
    		run("Enlarge...", "enlarge=-2"); 
    		roiManager("Add")				
		}

roiManager("Delete");

 if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

open(chnl_img + "Myosoft-1 DAPI.tif");
run("Set Scale...", "distance="+mic+" known=1 pixel="+pix+" unit=micron"); 
roiManager("Show All with labels");
roiManager("Measure");

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Max = getResult("Max",i);
			StdDev = getResult("StdDev",i);
			if((StdDev>250&&Max>2000)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};

roiManager("Delete");

 if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);

nbFibers=roiManager("count");
if (nbFibers > 0) {
		selectWindow("ROI Manager");
		for (i=0 ; i<nbFibers; i++) {
		    roiManager("select", i);
    		run("Enlarge...", "enlarge=5"); 
    		roiManager("Add");				
		}
roiManager("Delete");

open(myoD+myoTN);
run("Make Composite");
roiManager("Show All with labels");

roiManager("Measure");

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Min = getResult("Min",i);
			if((Min<1300)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};

roiManager("Delete"); 

 if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

roiManager("Measure");

run("Flatten");

saveAs("Results", dat_loc + "Central_Nuclei_Results.xlsx");
saveAs("Tiff", dat_loc + "Central_Nuclei_Results_RefImg");

waitForUser("Analysis Complete");