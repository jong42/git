import numpy as np
import Image 
import matplotlib as mpl
import matplotlib.pyplot as plt

def main():

	### import images
	im1 = Image.open("bilder/ele1.jpeg")
	im2 = Image.open("bilder/ele2.jpeg")
	im3 = Image.open("bilder/ele3.jpeg")
	im4 = Image.open("bilder/ele4.jpeg")
	im5 = Image.open("bilder/ele5.jpeg")
	im6 = Image.open("bilder/gir1.jpeg")
	im7 = Image.open("bilder/gir2.jpeg")
	im8 = Image.open("bilder/gir3.jpeg")
	im9 = Image.open("bilder/gir4.jpeg")
	im10 = Image.open("bilder/gir5.jpeg")
	
	### convert to equal size
	# Determine minimum size	
	sizes_x = []
	sizes_y = []

	sizes_x.append(im1.size[0])
	sizes_x.append(im2.size[0])
	sizes_x.append(im3.size[0])
	sizes_x.append(im4.size[0])
	sizes_x.append(im5.size[0])
	sizes_x.append(im6.size[0])
	sizes_x.append(im7.size[0])
	sizes_x.append(im8.size[0])
	sizes_x.append(im9.size[0])
	sizes_x.append(im10.size[0])

	sizes_y.append(im1.size[1])
	sizes_y.append(im2.size[1])
	sizes_y.append(im3.size[1])
	sizes_y.append(im4.size[1])
	sizes_y.append(im5.size[1])
	sizes_y.append(im6.size[1])
	sizes_y.append(im7.size[1])
	sizes_y.append(im8.size[1])
	sizes_y.append(im9.size[1])
	sizes_y.append(im10.size[1])

	# change size of images
	target_res = min(sizes_x),min(sizes_y)
	target_res = 100,100

	im1 = im1.resize(target_res, Image.ANTIALIAS)
	im2 = im2.resize(target_res, Image.ANTIALIAS)
	im3 = im3.resize(target_res, Image.ANTIALIAS)
	im4 = im4.resize(target_res, Image.ANTIALIAS)
	im5 = im5.resize(target_res, Image.ANTIALIAS)
	im6 = im6.resize(target_res, Image.ANTIALIAS)
	im7 = im7.resize(target_res, Image.ANTIALIAS)
	im8 = im8.resize(target_res, Image.ANTIALIAS)
	im9 = im9.resize(target_res, Image.ANTIALIAS)
	im10 = im10.resize(target_res, Image.ANTIALIAS)
	
	### convert colours to grey levels
	im1 = im1.convert("L")
	im2 = im2.convert("L")
	im3 = im3.convert("L")
	im4 = im4.convert("L")
	im5 = im5.convert("L")
	im6 = im6.convert("L")
	im7 = im7.convert("L")
	im8 = im8.convert("L")
	im9 = im9.convert("L")
	im10 = im10.convert("L")
	
	### convert images to matrix
	
	vec1 = np.asarray(im1).flatten()
	vec2 = np.asarray(im2).flatten() 
	vec3 = np.asarray(im3).flatten()
	vec4 = np.asarray(im4).flatten()  
	vec5 = np.asarray(im5).flatten()  
	vec6 = np.asarray(im6).flatten()  
	vec7 = np.asarray(im7).flatten()  
	vec8 = np.asarray(im8).flatten()  
	vec9 = np.asarray(im9).flatten()  
	vec10 = np.asarray(im10).flatten()    

	X_ele = np.column_stack([vec1,vec2,vec3,vec4,vec5])
	X_gir = np.column_stack([vec6,vec7,vec8,vec9,vec10])
	
	### SVD Zerlegung (dauert einige Minuten)

	U_ele, s_ele, V_ele = np.linalg.svd(X_ele,full_matrices=0, compute_uv=1)
	U_gir, s_gir, V_gir = np.linalg.svd(X_gir,full_matrices=0, compute_uv=1)
	
	#plt.imshow(U_gir.T[4].reshape(100,100), cmap='gray', interpolation='nearest')
	#plt.show()
	
	### plot singular values

	plt.plot(V_ele[0],V_ele[1],'b.',V_gir[0],V_gir[1],'y.',markersize=8)
	plt.show()
	
	###
	
	#print (X_ele.shape)
	#print (U_ele.shape)  # Eigenvektoren
	#print (s_ele.shape)
	#print (V_ele.shape)
	

	


if __name__ == '__main__':
    main()
