setup:
	mkdir -p data out model

download:
	@echo "Downloading dataset ..."
	wget -nc http://data.csail.mit.edu/places/places365/places365standard_easyformat.tar
	@echo "... done."
    	
extract:
	@echo "Extracting to data/ (if doesn't exist) ..."
	tar --keep-old-files -xf places365standard_easyformat.tar -C data/
	@echo "... done."

split:
	@echo 'Splitting dataset ...'
	# For each category:
	# 3968 pics from train/ will go to places10/train
	# 128  pics from train/ will go to places10/val
	python3 scripting/split-dataset.py data/places365_standard/train/ data/places10/ scripting/places10.txt train 3968 --bname val --bsize 128
	# 100  pics from val/   will go to places10/test
	python3 scripting/split-dataset.py data/places365_standard/val/ data/places10/ scripting/places10.txt test 100
	@echo  '... done.'
	@echo 'Please run `make run` to train the network.'


dataset: setup download extract
	@echo "Downloading, extracting and splitting dataset."
	@echo "Run `make split` to split the dataset"

run:
	python3 loader.py config/places10-full.yaml


zip_out:
	zip --quiet --recurse-paths out.zip out/
	rm -rf out/*
	@echo "Zipped all files in ./out into out.zip"

clean:
	rm -rf __pycache__/
	rm -rf src/__pycache__/
