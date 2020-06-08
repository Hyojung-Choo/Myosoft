
width = getWidth(); 
height = getHeight(); 
run("Close All") 

run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding shape feret's median redirect=None decimal=4");

waitForUser("choose place to save single channel images")
chnl_img = getDirectory("choose place to save single channel images");
waitForUser("choose place to save fiber type and morphometry data")
dat_loc = getDirectory("choose place to save fiber type and morphometry data");
waitForUser("choose place to save ROIs")
roi_loc = getDirectory("choose place to save ROIs");

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//----------------------------Set morphometry gates------------------------------------
// this module is where the ROI expansion factor is set. larger numbers increase degree 
// or enlargement. negative numbers shrink the ROI 

Dialog.create("Set scale");
Dialog.addMessage ("set scale for your image as pixels:microns");

Dialog.addNumber("pixels", 1);
Dialog.addNumber("microns", 0.32384);

Dialog.show();

pix = Dialog.getNumber();
mic = Dialog.getNumber();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//----------------------------color coder information------------------------------------
// this module is where the color coder information is input

cc_choice = newArray("[Red Hot]", "Fire", "[Orange Hot]", "physics") 

Dialog.create("Color Code info");
Dialog.addMessage ("input the maximum and minimum values used to establish the gradiaent for the color coder, color theme, and opacity of the overlay")
Dialog.addNumber("minimum value", 50);
Dialog.addSlider("Opacity", 1, 100, 80);
Dialog.addNumber("Maximum value", 4000);
Dialog.addChoice("Color Code", cc_choice);

Dialog.show();

min_cc = Dialog.getNumber();
opacity = Dialog.getNumber();
max_cc = Dialog.getNumber();
color_code = Dialog.getChoice();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------Fiber Typing--------------------------------------------------------------
//this module edits retrieves channel images from the first module and overlays the ROIs as a mask and measures
// values to obtain mean intensity. dat_loc and reference/ index images are saved to a location on the computer
open(chnl_img + "Myosoft-1 typeIIa.tif");
run("Set Scale...", "distance="+mic+" known=1 pixel="+pix+" unit=micron"); 

roiManager("Open", roi_loc+"total_smallROI.zip");

roiManager("Show All with labels");
roiManager("Measure");

run("Distribution...", "parameter=Mean automatic");
waitForUser("Determine IIa intensity gate");

selectWindow("Myosoft-1 typeIIa.tif");
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
roiManager("Open", roi_loc+"total_ROI.zip");

Dialog.create("Fiber Type Gates IIa");
Dialog.addMessage ("Fiber Type Gates IIa");
Dialog.addNumber("Type IIa Gate", 300);
Dialog.show();
IIaGt = Dialog.getNumber();

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mean = getResult("Mean",i);
			if((IIaGt<Mean)){
				roiManager("select", i); 
				roiManager("Add", i);
				};
		};

roiManager("Delete");
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   }; 


n_IIa=roiManager("count");
if (n_IIa>0) {
			roiManager("Save", roi_loc+"IIa_ROI.zip")
    		

newImage("Untitled", "8-bit white", width, height, 1);

roiManager("Show All without labels");

ROIArr = newArray("0");
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
roiManager("Set Fill Color", "black");

run("Flatten");
saveAs("Tiff", roi_loc + "BW_referenceImg_typeIIa");

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
};
		
else {
	print("No IIa fibers found");
};

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
open(chnl_img + "Myosoft-1 typeIIb.tif");
run("Set Scale...", "distance="+mic+" known=1 pixel="+pix+" unit=micron"); 


   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 

roiManager("Open", roi_loc+"total_smallROI.zip");

roiManager("Show All with labels");
//
roiManager("Measure");

run("Distribution...", "parameter=Mean automatic");
waitForUser("Determine IIb intensity gate");

selectWindow("Myosoft-1 typeIIb.tif");
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
roiManager("Open", roi_loc+"total_ROI.zip");

Dialog.create("Fiber Type Gates IIb");
Dialog.addMessage ("Fiber Type Gates IIb");
Dialog.addNumber("Type IIb Gate", 300);
Dialog.show();
IIbGt = Dialog.getNumber();

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mean = getResult("Mean",i);
			if((IIbGt<Mean)){
				roiManager("select", i); 
				roiManager("Add", i);
				};
		};

roiManager("Delete");
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 

n_IIb=roiManager("count");
if (n_IIb>0) {
			roiManager("Save", roi_loc+"IIb_ROI.zip")
    		

newImage("Untitled", "8-bit white", width, height, 1);

roiManager("Show All without labels");

ROIArr = newArray("0");
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
roiManager("Set Fill Color", "black");

run("Flatten");
saveAs("Tiff", roi_loc + "BW_referenceImg_typeIIb");

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
};
		
else {
	print("No IIb fibers found");
};

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

open(chnl_img + "Myosoft-1 typeI.tif");
run("Set Scale...", "distance="+mic+" known=1 pixel="+pix+" unit=micron"); 

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   
roiManager("Open", roi_loc+"total_ROI.zip");

roiManager("Show All with labels");
//
roiManager("Measure");


run("Distribution...", "parameter=Mean automatic");
waitForUser("Determine I intensity gate");

selectWindow("Myosoft-1 typeI.tif");
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
roiManager("Open", roi_loc+"total_ROI.zip");

Dialog.create("Fiber Type Gates I");
Dialog.addMessage ("Fiber Type Gates I");
Dialog.addNumber("Type I Gate", 300);
Dialog.show();
IGt = Dialog.getNumber();

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mean = getResult("Mean",i);
			if((IGt<Mean)){
				roiManager("select", i); 
				roiManager("Add", i);
				};
			};
roiManager("Delete");
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 

n_I=roiManager("count");
if (n_I>0) {
			roiManager("Save", roi_loc+"I_ROI.zip")
    		
newImage("Untitled", "8-bit white", width, height, 1);

roiManager("Show All without labels");

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
roiManager("Set Fill Color", "black");

run("Flatten");
saveAs("Tiff", roi_loc + "BW_referenceImg_typeI");

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
};

else {
	print("No Type I fibers found");
};
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

run("Close All");

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
if(n_IIa>0) {
open(roi_loc + "BW_referenceImg_typeIIa.tif");
if(n_IIb>0) {
roiManager("Open", roi_loc+"IIb_ROI.zip");
roiManager("Show All with labels");
//
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
			Mode = getResult("Mode",i);
			if((0==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};

roiManager("Delete");

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
}
};   
n_IIa_IIb=roiManager("count");
if (n_IIa_IIb>0) {
			roiManager("Save", roi_loc+"IIa_IIb_ROI.zip")
};
else {
	print("No IIb and IIa fibers found");
};

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if(n_IIa>0) {
open(roi_loc + "BW_referenceImg_typeIIa.tif");
if(n_I>0) {
roiManager("Open", roi_loc+"I_ROI.zip");
roiManager("Show All with labels");
//
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
			Mode = getResult("Mode",i);
			if((0==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};

roiManager("Delete");

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
}
};
n_IIa_I=roiManager("count");
if (n_IIa_I>0) {
		  		roiManager("Save", roi_loc+"IIa_I_ROI.zip")
    					
		};

else {
	print("No I and IIa fibers found");
};
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if(n_I>0) {   
open(roi_loc + "BW_referenceImg_typeI.tif");
if(n_IIb>0) {
roiManager("Open", roi_loc+"IIb_ROI.zip");
roiManager("Show All with labels");
//
roiManager("Measure");

ROIArr = newArray("0");
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((0==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};
roiManager("Delete");

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
};
};

n_I_IIb=roiManager("count");
if (n_I_IIb>0) {
			roiManager("Save", roi_loc+"I_IIb_ROI.zip")
   		};

else {
	print("No I and IIb fibers found");
};
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };

//////////////////////////////////////////////////////////////////////////////////////////////////////////////


   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
      if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
   if(n_I_IIb>0) {
roiManager("Open", roi_loc+"I_IIb_ROI.zip");
   
newImage("Untitled", "8-bit white", width, height, 1);

roiManager("Show All without labels");

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
roiManager("Set Fill Color", "black");
run("Flatten");

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   };
   
if(n_IIa>0) {
roiManager("Open", roi_loc+"IIa_ROI.zip");
roiManager("Show All without labels");
//
roiManager("measure")

ROIArr = newArray("0"); 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((0==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};
roiManager("Delete");
  
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
}
};   
n_I_IIb_IIa=roiManager("count");
if (n_I_IIb_IIa>0) {
	  		roiManager("Save", roi_loc+"I_IIb_IIa_ROI.zip")
    		};

else {
	print("No I IIb and IIa fibers found");
};
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
   if(n_I_IIb>0) {
roiManager("Open", roi_loc+"I_IIb_ROI.zip");
   }
   if(n_IIa_IIb>0) {
roiManager("Open", roi_loc+"IIa_IIb_ROI.zip");
   }
   if(n_I_IIb_IIa>0) {
roiManager("Open", roi_loc+"I_IIb_IIa_ROI.zip");
   };

n_IImixed=roiManager("count");
if(n_IImixed>0) {
newImage("Untitled", "8-bit white", width, height, 1);
roiManager("Show All without labels");

ROIArr = newArray("0"); 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
roiManager("Set Fill Color", "black");
run("Flatten");

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 

if(n_IIb>0) {
roiManager("Open", roi_loc+"IIb_ROI.zip");
//
roiManager("measure"); 

ROIArr = newArray("0"); 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((255==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};
roiManager("Delete");
 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
}; 
};
else{
	if(n_IIb>0) {
	 roiManager("Open", roi_loc+"IIb_ROI.zip");
}
};

n_IIb_only=roiManager("count");
if (n_IIb_only>0) {
	   		roiManager("Save", roi_loc+"IIb_only_ROI.zip")
    		};

else {
	print("No IIb only fibers found");
};
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
   if(n_I_IIb>0) {
roiManager("Open", roi_loc+"I_IIb_ROI.zip");
   }
   if(n_IIa_I>0) {
roiManager("Open", roi_loc+"IIa_I_ROI.zip");
   }
   if(n_I_IIb_IIa>0) {
roiManager("Open", roi_loc+"I_IIb_IIa_ROI.zip");
   };

n_Imixed=roiManager("count");
if(n_Imixed>0) {
newImage("Untitled", "8-bit white", width, height, 1);
roiManager("Show All without labels");

ROIArr = newArray("0");
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
roiManager("Set Fill Color", "black");
run("Flatten");

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
if(n_I>0) {
roiManager("Open", roi_loc+"I_ROI.zip");
roiManager("Show All without labels");
//
roiManager("measure"); 
};

ROIArr = newArray("0"); 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((255==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};
roiManager("Delete");
 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
};

else{
	if(n_I>0) {
roiManager("Open", roi_loc+"I_ROI.zip");
		
	};
};

n_I_only=roiManager("count");
if (n_I_only>0) {
	   		roiManager("Save", roi_loc+"I_only_ROI.zip")
    		};

else {
	print("No I only fibers found");
};
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
   if(n_IIa_IIb>0) {
roiManager("Open", roi_loc+"IIa_IIb_ROI.zip");
   }
   if(n_IIa_I>0) {
roiManager("Open", roi_loc+"IIa_I_ROI.zip");
   }
   if(n_I_IIb_IIa>0) {
roiManager("Open", roi_loc+"I_IIb_IIa_ROI.zip");
   };

n_IIamixed=roiManager("count");
if(n_IIamixed>0) {
newImage("Untitled", "8-bit white", width, height, 1);
roiManager("Show All without labels");

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
roiManager("Set Fill Color", "black");
run("Flatten");

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 

if(n_IIa>0) {   
roiManager("Open", roi_loc+"IIa_ROI.zip");
//
roiManager("measure"); 

ROIArr = newArray("0"); 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((255==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};
roiManager("Delete");
 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
};
};
else{
	if (n_IIa>0) {   
roiManager("Open", roi_loc+"IIa_ROI.zip");
}
};

n_IIa_only=roiManager("count");
if (n_IIa_only>0) {
	roiManager("Save", roi_loc+"IIa_only_ROI.zip")
    	};

else {
	print("No IIa only fibers found");
};
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if(n_IIa>0) {
roiManager("Open", roi_loc+"IIa_ROI.zip");
}
if(n_I>0) {
roiManager("Open", roi_loc+"I_ROI.zip");
}
if(n_IIb>0) {
roiManager("Open", roi_loc+"IIb_ROI.zip");
}

newImage("Untitled", "8-bit white", width, height, 1);
roiManager("Show All without labels");

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
roiManager("Set Fill Color", "black");
run("Flatten");

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
roiManager("Open", roi_loc+"total_ROI.zip");
roiManager("Show All without labels");
//
roiManager("measure"); 

ROIArr = newArray("0"); 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((255==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};
roiManager("Delete");
 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close");
   } 
run("Close All");   

n_IIx_only=roiManager("count");
if (n_IIx_only>0) {
	for (i=0 ; i<n_IIx_only; i++) {
  		roiManager("Save", roi_loc+"IIx_only_ROI.zip")
    	};
};
else {
	print("No IIx only fibers found");
};
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

if (n_I_IIb_IIa>0) {

roiManager("Open", roi_loc+"I_IIb_IIa_ROI.zip");
newImage("Untitled", "8-bit white", width, height, 1);
roiManager("Show All without labels");

ROIArr = newArray("0");
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
roiManager("Set Fill Color", "black");

run("Flatten");

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
   
 if(n_I_IIb>0) {
roiManager("Open", roi_loc+"I_IIb_ROI.zip");
roiManager("measure"); 

ROIArr = newArray("0");
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((255==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};
roiManager("Delete");
roiManager("Save", roi_loc+"I_IIb_ROI.zip")
   }
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
   
 if(n_IIa_I>0) {
roiManager("Open", roi_loc+"IIa_I_ROI.zip");
roiManager("measure"); 

ROIArr = newArray("0");
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((255==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};
roiManager("Delete");
roiManager("Save", roi_loc+"IIa_I_ROI.zip")
   }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
   
 if(n_IIa_IIb>0) {
roiManager("Open", roi_loc+"IIa_IIb_ROI.zip");
roiManager("measure"); 

ROIArr = newArray("0");
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((255==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};
roiManager("Delete");
roiManager("Save", roi_loc+"IIa_IIb_ROI.zip")
   }


}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
run("Set Measurements...", "area centroid center perimeter bounding shape feret's median redirect=None decimal=4");

newImage("Untitled", "8-bit white", width, height, 1);
   
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_IIa>0) {
roiManager("Open", roi_loc+"IIa_ROI.zip");
roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "IIa_Results.csv");
}

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_IIb>0) {
roiManager("Open", roi_loc+"IIb_ROI.zip");
//
roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "IIb_Results.csv");
}

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_I>0) {
roiManager("Open", roi_loc+"I_ROI.zip");
//
roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "I_Results.csv");
}

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   }   
if (n_IIx_only>0) {   
roiManager("Open", roi_loc+"IIx_only_ROI.zip");
//
roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "IIx_Results.csv");
}
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_IIa_only>0) {
roiManager("Open", roi_loc+"IIa_only_ROI.zip");
//
roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "IIa_only_Results.csv");
}
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_IIb_only>0) {
roiManager("Open", roi_loc+"IIb_only_ROI.zip");
//
roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "IIb_only_Results.csv");
}

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_I_only>0) {
roiManager("Open", roi_loc+"I_only_ROI.zip");
//
roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "I_only_Results.csv");
}
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_IIa_IIb>0) {
roiManager("Open", roi_loc+"IIa_IIb_ROI.zip");
//
roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "IIa_IIb_Results.csv");
}

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_IIa_I>0) {
roiManager("Open", roi_loc+"IIa_I_ROI.zip");
//

roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "IIa_I_Results.csv");
}

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_I_IIb>0) {
roiManager("Open", roi_loc+"I_IIb_ROI.zip");

//
roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "I_IIb_Results.csv");
}
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_I_IIb_IIa>0) {
roiManager("Open", roi_loc+"I_IIb_IIa_ROI.zip");
//

roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "I_IIb_IIa_Results.csv");
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////


run("Close All"); 

 if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   }; 
 
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   };
    
open(chnl_img + "Myosoft-1 membrane.tif");
roiManager("Open", roi_loc+"total_ROI.zip");
run("Set Scale...", "distance="+mic+" known=1 pixel="+pix+" unit=micron"); 
roiManager("Show All with labels");
roiManager("Measure");
run("Flatten");
saveAs("Tiff", dat_loc + "InputImageNameHere_referenceImg_area");
saveAs("Results", dat_loc + "Fiber_area_Results.csv");

selectWindow("Myosoft-1 membrane.tif");
run("ROI Color Coder", "measurement=Area lut="+color_code+" width=0 opacity="+opacity+" label=microns^2 range="+min_cc+"-"+max_cc+" n.=5 decimal=0 ramp=[256 pixels] font=SansSerif font_size=14 draw");

saveAs("Tiff", dat_loc + "color code legend");

selectWindow("Myosoft-1 membrane.tif");
run("Flatten");
saveAs("Tiff", dat_loc + "InputImageNameHere_referenceImg_ColorCode");

   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 
 
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   };
run("Close All");

waitForUser("Analysis Complete");