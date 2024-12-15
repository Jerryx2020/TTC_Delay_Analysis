# 2024 Toronto Transit Commission (TTC) Delay Analysis

This repository contains all the necessary information and files to replicate the analysis of delays across the Toronto Transit Commission’s (TTC) bus, subway, and streetcar services in 2024.

## Paper Overview

This paper investigates patterns and predictors of transit delays within the TTC network, focusing on three transit modes: buses, subways, and streetcars. Using data from [Open Data Toronto](https://open.toronto.ca/), the study examines the influence of geographic location, transit mode, and temporal factors on delay durations. A random forest model was used to predict `min_delay`, revealing that buses experience the highest delays due to their susceptibility to traffic congestion, while urban areas like Dundas exhibit longer delays than suburban locations such as Yorkdale. The findings provide actionable insights for transit planners, highlighting operational challenges and offering strategies to improve service reliability and commuter satisfaction.

## File Structure

The files for this research are organized as follows:

-   `data/00-simulated_data`: Simulated data created to test workflows and modeling.
-   `data/01-raw_data`: The raw TTC dataset obtained from Open Data Toronto.
-   `data/02-analysis_data`: The cleaned and combined dataset used for final analysis.
-   `models`: Contains the random forest model and feature importance outputs used in the paper.
-   `other/datasheet`: A detailed datasheet for the Open Data Toronto TTC dataset, including metadata and variable descriptions.
-   `other/sketches`: Previews of visualizations and models included in the final research paper.
-   `other/llm`: Documentation of ChatGPT usage during this project, including prompts and responses.
-   `paper`: Files used to generate the paper, including the Quarto file, bibliography, and the final paper PDF.
-   `scripts`: R scripts for simulating, cleaning, analyzing, and visualizing data, as well as modeling.

## Large Language Model (LLM) Usage Statement

This project utilized ChatGPT (ChatGPT-4 model) to assist in various stages, including research, data analysis, code development, and writing. All records of ChatGPT usage are documented in the `other/llm` folder, ensuring transparency and alignment with academic integrity standards.
