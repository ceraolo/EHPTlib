within EHPTlib.SupportModels.Miscellaneous;

model DragForceAngle "Vehicle rolling and aerodinamical drag force"
  import Modelica.Constants.g_n;
  extends Modelica.Mechanics.Translational.Interfaces.PartialElementaryOneFlangeAndSupport2;
  extends Modelica.Mechanics.Translational.Interfaces.PartialFriction;
  parameter Modelica.Units.SI.Mass m "vehicle mass";
  parameter Modelica.Units.SI.Density rho(start = 1.226) "air density";
  parameter Modelica.Units.SI.Area S "vehicle cross area";
  parameter Real fc(start = 0.01) "rolling friction coefficient";
  parameter Real Cx "aerodinamic drag coefficient";
  Modelica.Units.SI.Force dragForce "Total drag force";
  Modelica.Units.SI.Velocity v "vehicle velocity";
  Modelica.Units.SI.Acceleration a "Absolute acceleration of flange";
  parameter String DataFileName = "DataName.txt" "Name of file with angles function of s (rad) ex: \"Angle.txt\"";
  final parameter Real A = fc*m*g_n;
  final parameter Real A1 = m*g_n;
  final parameter Real B = 1/2*rho*S*Cx;
  final parameter Real mu[:, 2] = [0, 1];
  Real angle = sToAngle.y[1], Sign;
  Modelica.Units.SI.Length altimetry;
  Real debug = dragForce - B*v^2*Sign;
  // Constant auxiliary variable
  Modelica.Blocks.Tables.CombiTable1Ds sToAngle(tableOnFile = true, fileName = DataFileName, tableName = "Angle") annotation(
    Placement(transformation(extent = {{28, -10}, {8, 10}})));
equation
  der(altimetry) = v*sin(sToAngle.y[1]);
// Let us connect the table which determines angles:
  sToAngle.u = flange.s;
//  s = flange.s;
  v = der(s);
  a = der(v);
// Le seguenti definizioni seguono l'ordine e le richieste del modello "PartialFriction" di
// Modelica.Mechanics.Translational.Interfaces"
  v_relfric = v;
  a_relfric = a;
  f0 = A*cos(angle) + A1*sin(angle) "Friction force for v_relfric=0 and forward sliding";
  f0_max = A "Maximum friction force for v_relfric=0 and locked";
  free = false "true when there is not wheel-road contact (never!)";
// Ora il calcolo di dragForce, e la sua attribuzione alla flangia:
  flange.f - dragForce = 0;
// friction force
  if v > 0 then
    Sign = 1;
  else
    Sign = -1;
  end if;
//The following equation equates dragForce to the force applied when locked=true, otherwise term A.
  dragForce - B*v^2*Sign = if locked then sa*unitForce else f0*(if startForward then Modelica.Math.Vectors.interpolate(mu[:, 1], mu[:, 2], v) else if startBackward then -Modelica.Math.Vectors.interpolate(mu[:, 1], mu[:, 2], -v) else if pre(mode) == Forward then Modelica.Math.Vectors.interpolate(mu[:, 1], mu[:, 2], v) else -Modelica.Math.Vectors.interpolate(mu[:, 1], mu[:, 2], -v));
  annotation(
    Documentation(info = "<html><head></head><body><p>This component models the total (rolling and aerodynamic vehicle drag resistance, also considering road slope (angle):</p>
            <p>F=m*g*sin(angle) + &nbsp;fc*m*g*cos(angle) + (1/2)*rho*Cx*S*v^2</p>
            <p>It is a variation of DragForce model.</p><p><br></p>
            </body></html>"),
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Polygon(points = {{-98, 10}, {22, 10}, {22, 41}, {92, 0}, {22, -41}, {22, -10}, {-98, -10}, {-98, 10}}, lineColor = {0, 127, 0}, fillColor = {215, 215, 215}, fillPattern = FillPattern.Solid), Line(points = {{-90, -90}, {-70, -88}, {-50, -82}, {-30, -72}, {-10, -58}, {10, -40}, {30, -18}, {50, 8}, {70, 38}, {90, 72}}, color = {0, 0, 255}, thickness = 0.5), Text(extent = {{-82, 90}, {80, 50}}, lineColor = {0, 0, 255}, textString = "%name"), Line(points = {{32, 48}, {-62, -38}, {64, -40}}, color = {238, 46, 47}, thickness = 0.5), Polygon(points = {{-20, 0}, {-8, -10}, {0, -26}, {2, -38}, {-62, -38}, {-20, 0}}, lineColor = {238, 46, 47}, fillColor = {128, 128, 128}, fillPattern = FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 60}}), graphics = {Text(extent = {{-58, -30}, {68, -48}}, lineColor = {0, 0, 0}, lineThickness = 0.5, fillColor = {128, 128, 128}, fillPattern = FillPattern.Solid, textString = "Connections of sToAngle made internally")}));
end DragForceAngle;
