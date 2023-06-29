within EHPTlib.SupportModels.MapBasedRelated;
block LimTau "Torque limiter"
  Modelica.Blocks.Interfaces.RealInput w annotation (
    Placement(transformation(extent = {{-140, -20}, {-100, 20}}), iconTransformation(extent = {{-140, -20}, {-100, 20}})));
  Modelica.Blocks.Interfaces.RealOutput yH annotation (
    Placement(transformation(extent = {{100, 50}, {120, 70}})));
  parameter Modelica.Units.SI.Power powMax=50000
    "Maximum mechanical power";
  parameter Modelica.Units.SI.Torque tauMax=400 "Maximum torque ";
  parameter Modelica.Units.SI.AngularVelocity wMax= 1500 "Maximum speed";
  Integer state "=0 below base speed; =1 before wMax; =2 in w limit, =3 above wMax";
  //0 or 1 if tauMax or powMax is delivered; =2 or 3 if w>wMax
protected
  parameter Real alpha = 0.10 "fraction of wMax over which the torque is to be brought to zero";
public
  Modelica.Blocks.Interfaces.RealOutput yL annotation (
    Placement(transformation(extent = {{100, -70}, {120, -50}})));
algorithm
  if w < powMax / tauMax then
    state := 0;
    yH := tauMax;
  else
    state := 1;
    yH := powMax / w;
  end if;
  //over wMax the torque max is to be rapidly brought to zero
  if w > wMax then
    if w < (1 + alpha) * wMax then
      state := 2;
      yH := powMax / wMax * (1 - (w - wMax) / (alpha * wMax));
    else
      state := 3;
      yH := 0;
    end if;
  end if;
  yL := -yH;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Text(extent = {{-98, 126}, {96, 90}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, textString = "%name
          "),
        Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 90}, {100, -88}}), Line(points = {{-72, 80}, {-72, -80}}, arrow = {Arrow.Filled, Arrow.None}, arrowSize = 2), Text(lineColor = {0, 0, 255}, extent = {{-98, 54}, {-84, 48}}, textString = "T"), Line(points = {{92, -2}, {-74, -2}}, arrow = {Arrow.Filled, Arrow.None}, arrowSize = 2), Text(lineColor = {0, 0, 255}, extent = {{72, -22}, {86, -28}}, textString = "W"), Line(points = {{-72, 54}, {-12, 54}, {-2, 40}, {16, 26}, {30, 18}, {44, 14}}), Line(points = {{-72, -58}, {-12, -58}, {-2, -44}, {16, -30}, {30, -22}, {42, -18}})}),
    Documentation(info = "<html>
      <p>Gives the maximum output torque as a function of the input speed.</p>
      <p>When w&LT;wMax the output is Tmax if Tmax*w&LT;Pnom, othersise it is Pnom/w</p>
      <p>But if w is over wMax Tmax is rapidly falling to zero (reaches zero when speed overcomes wMax by 10&percnt;).</p>
      <p>Torques and powers are in SI units</p>
      </html>"));
end LimTau;
