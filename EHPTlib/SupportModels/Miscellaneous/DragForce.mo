within EHPTlib.SupportModels.Miscellaneous;
model DragForce "Vehicle rolling and aerodinamical drag force"
  import Modelica.Constants.g_n;
  extends
    Modelica.Mechanics.Translational.Interfaces.PartialElementaryOneFlangeAndSupport2;
  extends Modelica.Mechanics.Translational.Interfaces.PartialFriction;
  Modelica.Units.SI.Force f "Total drag force";
  Modelica.Units.SI.Velocity v "vehicle velocity";
  Modelica.Units.SI.Acceleration a "Absolute acceleration of flange";
  Real Sign;
  parameter Modelica.Units.SI.Mass m "vehicle mass";
  parameter Modelica.Units.SI.Density rho=1.226 "air density";
  parameter Modelica.Units.SI.Area S "vehicle cross area";
  parameter Real fc(start = 0.01) "rolling friction coefficient";
  parameter Real Cx "aerodinamic drag coefficient";
protected
  parameter Real A = fc * m * g_n;
  parameter Real B = 1 / 2 * rho * S * Cx;
  constant Real f_pos[:,2]=[0,1];
equation
  //  s = flange.s;
  v = der(s);
  a = der(v);
  // Le seguenti definizioni seguono l'ordine e le richieste del modello "PartialFriction" di
  // Modelica.Mechanics.Translational.Interfaces"
  v_relfric = v;
  a_relfric = a;
  f0 = A "force at 0 speed 0 but with slip";
  f0_max = A "max force at 0 speed without slip";
  free = false "in principle should become true whenthe wheel loose contact with road";
  // Now the computation of f, and its attribution to the flange:
  flange.f - f = 0;
  // friction force
  if v > 0 then
    Sign = 1;
  else
    Sign = -1;
  end if;
  //The following equation equates dragForce to the force applied when locked=true, otherwise term A.
  f - B * v ^ 2 * Sign = if locked then sa * unitForce else f0 * (if startForward then Modelica.Math.Vectors.interpolate(f_pos[:, 1], f_pos[:, 2], v, 1) else if startBackward then -Modelica.Math.Vectors.interpolate(f_pos[:, 1], f_pos[:, 2], -v, 1) else if pre(mode) == Forward then Modelica.Math.Vectors.interpolate(f_pos[:, 1], f_pos[:, 2], v, 1) else -Modelica.Math.Vectors.interpolate(f_pos[:, 1], f_pos[:, 2], -v, 1));

  /*  
      f - B * v ^ 2 * Sign =if locked then sa*unitForce else f0*(if startForward
     then ObsoleteModelica4.Math.tempInterpol1(
    v,
    [0,1],
    2) else if startBackward then -ObsoleteModelica4.Math.tempInterpol1(
    -v,
    [0,1],
    2) else if pre(mode) == Forward then ObsoleteModelica4.Math.tempInterpol1(
    v,
    [0,1],
    2) else -ObsoleteModelica4.Math.tempInterpol1(
    -v,
    [0,1],
    2));
*/

  annotation (
    Documentation(info = "<html>
<p>This component models the total (rolling and aerodynamic) vehicle drag resistance: </p>
<p>F=fc*m*g+(1/2)*rho*Cx*S*v^2 </p>
<p>It models reliably the stuck phase. Based on Modelica-Intrerfaces.PartialFriction model </p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics={  Polygon(points = {{-98, 10}, {22, 10}, {22, 41}, {92, 0}, {22, -41}, {22, -10}, {-98, -10}, {-98, 10}}, lineColor = {0, 127, 0}, fillColor = {215, 215, 215}, fillPattern = FillPattern.Solid), Line(points = {{-42, -50}, {87, -50}}, color = {0, 0, 0}), Polygon(points = {{-72, -50}, {-41, -40}, {-41, -60}, {-72, -50}}, lineColor = {0, 0, 0}, fillColor = {128, 128, 128}, fillPattern = FillPattern.Solid), Line(points = {{-90, -90}, {-70, -88}, {-50, -82}, {-30, -72}, {-10, -58}, {10, -40}, {30, -18}, {50, 8}, {70, 38}, {90, 72}, {110, 110}}, color = {0, 0, 255}, thickness = 0.5), Text(extent = {{-82, 90}, {80, 50}}, lineColor = {0, 0, 255}, textString = "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics));
end DragForce;
