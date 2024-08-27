within EHPTlib.SupportModels.MapBasedRelated;
block LimTorque
  "Defines torque limits based on values from a CombiTable"
  Modelica.Blocks.Interfaces.RealInput w annotation (
    Placement(transformation(extent = {{-140, -20}, {-100, 20}}), iconTransformation(extent = {{-140, -20}, {-100, 20}})));
  Modelica.Blocks.Interfaces.RealOutput yH annotation (
    Placement(transformation(extent = {{100, 50}, {120, 70}})));
  parameter Boolean limitsOnFile = false "= true, if max torque is taken from a txt file";
  parameter Boolean normalisedInput = false "when true, input torque limits are normalised (will be multiplied by wMax and tauMax)"
   annotation(Dialog(enable = limitsOnFile));

  parameter Modelica.Units.SI.Power powMax=50000
    "Maximum mechanical power"
    annotation (Dialog(enable=not limitsOnFile));
  parameter Modelica.Units.SI.Torque tauMax=400 "Maximum torque"
    annotation (Dialog(enable=not limitsOnFile));
  parameter Modelica.Units.SI.AngularVelocity wMax= 1500 "Maximum speed" annotation (Dialog(enable=not limitsOnFile));
  parameter String limitsFileName = "noName" "File where matrix is stored" annotation (
    Dialog(enable = limitsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required table is")));
  parameter String maxTorqueTableName = "noName" "Name of the on-file maximum torque as a function of speed" annotation (
    Dialog(enable = limitsOnFile));
  parameter String minTorqueTableName = "noName" "Name of the on-file minimum torque as a function of speed" annotation (
    Dialog(enable = limitsOnFile));
  Integer state "=0 below base speed; =1 before wMax; =2 in w limit, =3 above wMax";
  //0 or 1 if tauMax or powMax is delivered; =2 or 3 if w>wMax; -1 if limitsOnFile
  Real yHidealised "valore del limite di coppia in caso di curve idealizzate (T cost. sotto la velocità base, P cost. sopra)";
protected
  parameter Real alpha = 0.10 "fraction of wMax over which the torque is to be brought to zero";
  constant Real one = 1.0;

public
  Modelica.Blocks.Interfaces.RealOutput yL annotation (
    Placement(transformation(extent = {{100, -70}, {120, -50}})));
  Modelica.Blocks.Tables.CombiTable1Ds toMaxTq(tableOnFile = limitsOnFile,
       table = [0, 0; 1, 1; 2, 4], tableName = maxTorqueTableName,
       fileName = limitsFileName,
       smoothness = Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2,
       extrapolation = Modelica.Blocks.Types.Extrapolation.LastTwoPoints)
   annotation (
    Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Blocks.Tables.CombiTable1Ds toMinTq(tableOnFile = limitsOnFile,
      table = [0, 0; 1, 1; 2, 4], tableName = minTorqueTableName,
      fileName = limitsFileName,
      smoothness = Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2,
      extrapolation = Modelica.Blocks.Types.Extrapolation.LastTwoPoints)
       annotation (
    Placement(transformation(extent={{40,-50},{60,-30}})));
  Modelica.Blocks.Math.UnitConversions.To_rpm to_rpm if not normalisedInput
   annotation (
    Placement(transformation(extent={{-60,-32},{-40,-12}})));
  Modelica.Blocks.Math.Gain gain(k=one) if normalisedInput
    annotation (Placement(transformation(extent={{-60,18},{-40,38}})));
algorithm
  if w < powMax / tauMax then
    state := 0;
    yHidealised := tauMax;
  else
    state := 1;
    yHidealised := powMax / w;
  end if;
  //over wMax the torque max is to be rapidly brought to zero
  if w > wMax then
    if w < (1 + alpha) * wMax then
      state := 2;
      yHidealised := powMax / wMax * (1 - (w - wMax) / (alpha * wMax));
    else
      state := 3;
      yHidealised := 0;
    end if;
  end if;
  if limitsOnFile then
    state := -1;
  end if;
equation
  if limitsOnFile then
    yH = toMaxTq.y[1];
    yL = toMinTq.y[1];
  else
    yH = yHidealised;
    yL = -yHidealised;
  end if;
  connect(w, to_rpm.u) annotation (
    Line(points={{-120,0},{-84,0},{-84,-22},{-62,-22}},
                                         color = {0, 0, 127}));
  connect(toMaxTq.u, toMinTq.u) annotation (
    Line(points={{38,40},{20,40},{20,-40},{38,-40}},              color = {0, 0, 127}));
  connect(to_rpm.y, toMinTq.u) annotation (
    Line(points={{-39,-22},{20,-22},{20,-40},{38,-40}},         color = {0, 0, 127}));
  connect(gain.y, toMinTq.u) annotation (Line(points={{-39,28},{20,28},{20,-40},
          {38,-40}}, color={0,0,127}));
  connect(gain.u, w) annotation (Line(points={{-62,28},{-84,28},{-84,0},{-120,0}},
        color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}),
        graphics={
        Text(
          extent={{-24,16},{18,-12}},
          textColor={238,46,47},
          textString="true

false"),Text(
          extent={{-64,8},{-16,-2}},
          textColor={238,46,47},
          textString="normalisedInput")}),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={
        Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 90}, {100, -88}}), Line(points = {{-72, 80}, {-72, -80}}, arrow = {Arrow.Filled, Arrow.None}, arrowSize = 2), Text(lineColor = {0, 0, 255}, extent = {{-98, 54}, {-84, 48}}, textString = "T"), Line(points = {{92, -2}, {-74, -2}}, arrow = {Arrow.Filled, Arrow.None}, arrowSize = 2), Text(lineColor = {0, 0, 255}, extent = {{72, -22}, {86, -28}}, textString = "W"), Line(points = {{-72, 54}, {-12, 54}, {2, 46}, {16, 26}, {30, 18}, {43.9863, 14.0039}, {86, 10}}, thickness = 0.5), Line(points = {{-72, -2}, {-62, -2}, {-52, -48}, {-8, -48}, {4, -42}, {16, -20}, {34, -12}, {86, -8}}, thickness = 0.5),
                                                                                                         Text(extent={{-100,
              128},{100,64}},                                                                                                                  lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, textString = "%name
          ")}),
    Documentation(info = "<html>
<p>Gives the maximum output torque as a function of the input speed. </p>
<p>There are two possibilities dependig on the value of limitsOnFile.</p>
<p><b>If limitsOnFile=false</b></p>
<p>When w&lt;wMax the output is Tmax if Tmax*w&lt;Pnom, othersise it is Pnom/w </p>
<p>But if w is over wMax Tmax is rapidly falling to zero (reaches zero when speed overcomes wMax by 10&percnt;). </p>
<p><b>If limitsOnFile=true</b></p>
<p>maximum and minimum torques arre taken from a txt file. Default interpaltion is with ontinuous derivative. No maxmimum speed is considered.</p>
<p><br>Torques and powers are in SI units </p>
</html>"));
end LimTorque;
