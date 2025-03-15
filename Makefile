.PHONY: all clean report

all: 
	make clean
	make index.html

report:
	make index.html

index.html:	data/original/car.data \
			output/encoded.RDS \
			output/matrix.RDS \
			output/tbl_target_dist.RDS \
			output/fig_target_dist.png \
			output/fig_target_safety_1.png \
			output/fig_target_buying_1.png \
			output/fig_target_persons_1.png \
			output/fig_target_maint_1.png \
			output/fig_target_lug_boot_1.png \
			output/fig_target_doors_1.png \
			output/fig_target_safety_2.png \
			output/fig_target_buying_2.png \
			output/fig_target_persons_2.png \
			output/fig_target_maint_2.png \
			output/fig_target_lug_boot_2.png \
			output/fig_target_doors_2.png \
			output/fig_smote_dist.png \
			output/fig_corr_heatmap.png \
			output/fig_conf_matrix.png \
			reports/car_acceptability_category_prediction.html \
			reports/car_acceptability_category_prediction.pdf 
			quarto render reports/car_acceptability_category_prediction.qmd
			mv reports/car_acceptability_category_prediction.html docs/index.html

# 01-load.R
data/original/car.data: code/01-load.R 
	Rscript code/01-load.R \
		--url_path="https://archive.ics.uci.edu/static/public/19/car+evaluation.zip" \
		--output_path=data/original/

# 02-clean-process.R
output/encoded.RDS: code/02-clean-process.R
	Rscript code/02-clean-process.R --file_path=data/original/car.data --data_path=data/cleaned/cleaned.RDS \
		--encode_path=output/encoded.RDS

		
# 03-visualizations.R
output/fig_target_dist.png output/fig_target_safety_1.png output/fig_target_buying_1.png output/fig_target_persons_1.png output/fig_target_maint_1.png output/fig_target_lug_boot_1.png output/fig_target_doors_1.png output/fig_target_safety_2.png output/fig_target_buying_2.png output/fig_target_persons_2.png output/fig_target_maint_2.png output/fig_target_lug_boot_2.png output/fig_target_doors_2.png  output/fig_smote_dist.png output/fig_corr_heatmap.png output/fig_conf_matrix.png: output/tbl_target_dist.RDS
  output/tbl_target_dist.RDS: code/03-visualizations.R
	Rscript code/03-visualizations.R --data_path=data/cleaned/cleaned.RDS --encode_path=output/encoded.RDS --matrix_path=output/matrix.RDS \
		--output_path=output/

# 04-analysis.R
output/matrix.RDS: code/04-analysis.R
		Rscript code/04-analysis.R  --file_path=output/encoded.RDS \
		--output_path=output/matrix.RDS 


# render quarto report in HTML and PDF
reports/car_acceptability_category_prediction.html: output reports/car_acceptability_category_prediction.qmd
	quarto render reports/car_acceptability_category_prediction.qmd --to html

reports/car_acceptability_category_prediction.pdf: output reports/car_acceptability_category_prediction.qmd
	quarto render reports/car_acceptability_category_prediction.qmd --to pdf


# clean
clean: 
		rm -rf data/cleaned/*
		rm -rf data/original/*
		rm -rf output/*
		rm -rf docs/*
		rm -rf reports/car_acceptability_category_prediction.html \
				reports/car_acceptability_category_prediction.pdf