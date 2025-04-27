# Data Processing and Zak Phase Calculator

This MATLAB GUI application is designed for:
- Importing and filtering data
- Drawing rotation diagrams
- Calculating Zak Phase
- Saving generated plots

## Features

- **Import Data**: Load a `.txt` file containing your dataset.
- **Filter Data**: Apply an imaginary part threshold to filter the data.
- **Calculate Zak Phase**: Compute the Zak Phase based on the filtered dataset.
- **Draw Rotation Diagram**: Visualize rotation properties by generating a rotation diagram.
- **Save Rotation Diagram**: Save the rotation diagram as `.png`, `.jpg`, or `.fig` files.
- **Exit**: Close the application.

## Usage Instructions

1. **Launch the Application**  
   Run the `apps.m` script in MATLAB.

2. **Import Data**  
   Click **Import Data** and select your `.txt` file.  
   The data should be organized appropriately, with useful content starting from line 6.

3. **Filter Data**  
   Click **Filter Data**.  
   You will be prompted to enter an `imagThreshold` value.  
   After filtering, a new file `q1234fixed-modified.txt` will be generated.

4. **Calculate Zak Phase**  
   After filtering, click **Calculate Zak Phase**.  
   Enter the parameters `realmin` and `realThreshold` as prompted.  
   The Zak Phase will be calculated and displayed.

5. **Draw Rotation Diagram**  
   Click **Draw Rotation Diagram** to visualize the rotation properties of your system.

6. **Save Rotation Diagram**  
   After drawing the diagram, click **Save Rotation Diagram** to export the figure in your preferred format (`.png`, `.jpg`, `.fig`).

7. **Exit the Application**  
   Click **Exit** to close the GUI.

## Notes

- Make sure the auxiliary functions `modify.m`, `drawRotationDiagram.m`, and `funcs.m` are in the same folder as `apps.m`.
- Ensure your input `.txt` file format matches the expected structure (starting from line 6 for data).
- This application is intended for educational and research use in photonic, condensed matter, and related fields.
