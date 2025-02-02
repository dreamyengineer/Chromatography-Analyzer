# Chromatographic Data Analysis (Gas Chromatography) in MATLAB

This repository contains a **MATLAB Live Script** designed to import and analyze chromatographic data from Agilent `.ch` files. The goal is to process data from multiple experiments for a given sample and reliably identify compound peaks and their concentrations based on user-provided conversion tables.

## Overview

1. **Data Import:**  
   - The Live Script prompts the user to select Agilent `.ch` files via a file dialog.  
   - No strict naming convention or folder structure is required; you can import any valid `.ch` files from your system.

2. **Pre-processing:**
   - **Solvent Subtraction:** Data from the solvent run is subtracted from the sample data for each experiment to eliminate solvent-related signals.  
   - **Baseline Correction:** A baseline is fitted and subtracted to account for drift and noise in the measurements.

3. **Peak Detection & Alignment:**
   - Peaks are identified in each of the three replicate measurements.  
   - A tolerance-based matching of peaks across these three replicates ensures that only those peaks present in all three measurements are considered.

4. **Peak Fitting:**
   - After identifying common peaks, the script fits them (e.g., Gaussian or other models) to separate overlapping peaks more accurately.  
   - Peak positions correspond to specific compounds, and integrated peak areas are used for concentration calculations.

5. **Compound Identification & Concentration:**
   - Retention times and integrated areas are converted into compound names and concentrations via user-provided Excel tables.  
   - The Excel tables should be formatted similarly to the provided examples (column layout, headers, etc.).

6. **Output:**
   - The script displays diagnostic plots (before/after baseline correction, peak detection, etc.) to help the user assess data quality.  
   - Key results are saved to the MATLAB workspace.  
   - A final Excel file is generated, containing compound names and concentrations.

## Requirements

1. **MATLAB** (tested on version R2024b or later).  
2. **MATLAB Toolboxes:**  
   - Bioinformatics Toolbox  
   - Signal Processing Toolbox  
   - Statistics and Machine Learning Toolbox  
3. **Example Excel Conversion Table:**  
   - A user-provided Excel file with columns for retention times, compound names, and conversion factors (use the sample file in this repository as a template).

## Usage Instructions

1. **Clone or Download** this repository to your local machine.  
2. Open MATLAB and ensure all files in this repository are on the MATLAB path.  
3. Open the main Live Script (`.mlx` file).  
4. **Run the Script Section-by-Section:**  
   - **Section 1:** Imports the `.ch` files. A file dialog will appear; select all the data files you wish to process.  
   - **Section 2:** Performs solvent subtraction. Ensure you also select the solvent runs if prompted.  
   - **Section 3:** Conducts baseline correction. Adjust parameters in the script if needed (for example, polynomial order or smoothing).  
   - **Section 4:** Identifies peaks in each replicate. Fine-tune the peak detection parameters (e.g., minimum peak height, distance between peaks).  
   - **Section 5:** Matches peaks across the three replicates. The tolerance for matching can be adjusted.  
   - **Section 6:** Fits each peak with a chosen model (e.g., Gaussian). You can customize the fitting parameters.  
   - **Section 7:** Converts retention times and areas to compound names and concentrations using Excel conversion tables.  
   - **Section 8:** Exports final results to Excel and displays final figures for verification.

> **Important:** Live Scripts can sometimes be finicky. If you encounter errors running the entire script at once, please proceed through each section manually, ensuring any required variables are correctly passed between sections.

## Known Issues & Caveats

- **Peak Identification Robustness:**  
  - If the chosen peak detection parameters (baseline threshold, minimum peak prominence, etc.) are not well-tuned, the script may incorrectly identify peaks or miss them entirely.  
  - Overlapping peaks with very similar retention times can still confuse the code.
- **Retention Time Shift / Tolerance:**  
  - For best results, make sure the retention time tolerances are chosen appropriately. If shifts are large, the script might fail to match peaks across replicates.
- **Data Noise:**  
  - Extremely noisy data or poor baseline might lead to inconsistent results. Adjust baseline correction and smoothing parameters if needed.
- **Script Maturity:**  
  - This project is in its infancy and very much a work-in-progress. Expect some bugs and potential errors if inputs are outside expected ranges. Feedback and contributions are welcome!

## Contributing

If you’d like to **contribute** by improving the script, fixing bugs, or adding new features:
- Fork this repository.
- Create a new branch for your changes.
- Submit a Pull Request describing what you’ve changed.

## License
MIT License

Copyright (c) 2025 dreamyengineer (Gabriel Brinkmann)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

**Questions or Issues?**  
Please open an issue on GitHub or contact me directly if you need further assistance. Any feedback on improvements, bug reports, or feature requests is greatly appreciated!
