within EHPTlib.SupportModels.MapBasedRelated;
block EffiPlot "Utility to plot efficiencies from an effTable"
  import wbEHPTlib =
         EHPTlib;
  parameter Real tauMax(start = 400) "Maximum machine torque(Nm)";
  parameter Real powMax(start = 22000) "Maximum drive power";
  parameter Real wMax(start = 650) "Maximum machine speed(rad/s)";
  parameter Real effTable[:, :] = [0.00, 0.00, 0.25, 0.50, 0.75, 1.00; 0.00, 0.75, 0.80, 0.81, 0.82, 0.83; 0.25, 0.76, 0.81, 0.82, 0.83, 0.84; 0.50, 0.77, 0.82, 0.83, 0.84, 0.85; 0.75, 0.78, 0.83, 0.84, 0.85, 0.87; 1.00, 0.80, 0.84, 0.85, 0.86, 0.88];
  Real tau[size(effs, 1)];
  Real effs[:] = {0.75, 0.775, 0.8, 0.825, 0.85, 0.875};
  Modelica.Blocks.Tables.CombiTable2Ds effTable_[size(effs, 1)](
    each tableOnFile=false,
    each smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    each table=effTable) "normalised efficiency" annotation (Placement(
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={-2,0})));
equation
  for i in 1:size(effs, 1) loop
    effTable_[i].y = effs[i];
    effTable_[i].u1 = time;
    effTable_[i].u2 = tau[i];
  end for;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -80}, {100, 80}})),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Rectangle(extent = {{-100, 72}, {100, -72}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Line(points = {{-74, -54}, {-74, 58}}, color = {0, 0, 0}, smooth = Smooth.None), Line(points = {{-82, -48}, {78, -48}}, color = {0, 0, 0}, smooth = Smooth.None), Line(points = {{-74, 38}, {-24, 38}, {-4, 12}, {28, -8}, {60, -22}, {62, -48}}, color = {0, 0, 0}, smooth = Smooth.None), Polygon(points = {{-20, 14}, {-40, 24}, {-56, -4}, {-38, -36}, {12, -38}, {26, -28}, {22, -20}, {8, -6}, {-8, 4}, {-20, 14}}, lineColor = {0, 0, 0}, smooth = Smooth.None, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Polygon(points = {{-28, 4}, {-38, 2}, {-32, -20}, {0, -32}, {10, -28}, {12, -20}, {-28, 4}}, lineColor = {0, 0, 0}, smooth = Smooth.None, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-102, 118}, {100, 78}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, textString = "%name"), Text(extent = {{26, 46}, {76, 4}}, lineColor = {0, 0, 0}, textString = "M")}),
    Documentation(info = "<html>
<p>This block computes the machine and inverter losses from the mechanical input quantities and determines the power to be drawn from the electric circuit. The &QUOT;drawn&QUOT; power can be also a negative numer, meaning that themachine is actually delivering electric power.</p>
<p>The given efficiency map is intended as being built with torques being ratios of actual torques to tauMax and speeds being ratios of w to wMax. In case the user uses, in the given efficiency map, torques in Nm and speeds in rad/s, the block can be used selecting tauTmax=1, wMax=1.</p>
<p>The choice of having normalised efficiency computation allows simulations of machines different in sizes and similar in characteristics to be repeated without having to rebuild the efficiency maps. </p>
<p>Torques are written in the first matrix column, speeds on the first row.</p>
</html>"));
end EffiPlot;
