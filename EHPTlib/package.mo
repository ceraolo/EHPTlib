package EHPTlib "Electric and Hybrid Power train library Rev Jan 2023"
      //Symbol to force Dymola to use UTF: €
  //package Propulsion
  extends Modelica.Icons.Package;
  //end Propulsion;

  annotation (
     version = "3.0.0",
     uses(Modelica(version="4.0.0")),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Polygon(points = {{-60, 16}, {78, 16}, {94, 0}, {96, -16}, {-98, -16}, {-90, 0}, {-76, 12}, {-60, 16}}, lineColor = {0, 0, 0}, smooth = Smooth.None, fillColor = {0, 0, 255},
       fillPattern = FillPattern.Solid), Ellipse(extent = {{-70, -4}, {-30, -40}}, lineColor = {95, 95, 95}, fillColor = {95, 95, 95},
       fillPattern = FillPattern.Solid), Ellipse(extent = {{34, -6}, {74, -42}}, lineColor = {95, 95, 95}, fillColor = {95, 95, 95},
       fillPattern = FillPattern.Solid), Polygon(points = {{-54, 16}, {-18, 46}, {46, 46}, {74, 16}, {-54, 16}}, lineColor = {0, 0, 0}, smooth = Smooth.None, fillColor = {0, 0, 255},
       fillPattern = FillPattern.Solid), Ellipse(extent = {{-86, -6}, {-92, 4}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 0},
       fillPattern = FillPattern.Solid), Ellipse(extent = {{98, -10}, {92, -4}}, lineColor = {0, 0, 0}, fillColor = {255, 0, 0},
       fillPattern = FillPattern.Solid), Polygon(points = {{-46, 20}, {-20, 42}, {16, 42}, {14, 20}, {-46, 20}}, lineColor = {0, 0, 0}, smooth = Smooth.None, fillColor = {255, 255, 255},
       fillPattern = FillPattern.Solid), Polygon(points = {{22, 42}, {42, 42}, {60, 20}, {20, 20}, {22, 42}}, lineColor = {0, 0, 0}, smooth = Smooth.None, fillColor = {255, 255, 255},
       fillPattern = FillPattern.Solid), Ellipse(extent = {{-60, -12}, {-40, -30}}, lineColor = {95, 95, 95}, fillColor = {215, 215, 215},
       fillPattern = FillPattern.Solid), Ellipse(extent = {{44, -14}, {64, -32}}, lineColor = {95, 95, 95}, fillColor = {215, 215, 215},
       fillPattern = FillPattern.Solid)}),
    Documentation(info= "<html><head></head><body><p>Library containing models of components, subsystems and full vehicles examples for simulation of electric and Hybrid vehicular power trains.</p>
<p>A general, now very old, description of the library composition and on how to use it effectively is in the companion paper:</p>
<p>M. Ceraolo \"Modelica Electric and hybrid power trains library\" submitted for publication at the 11th International Modelica Conference, 2015, September 21-23, Palais des congrès de Versailles, 23-23 September, France</p>
<p>An updated description of the library and its usage can be found in file Tutorial.pdf\", which comes with library https://github.com/ceraolo/EHPTexamples.</p>
</body></html>"));
end EHPTlib;
