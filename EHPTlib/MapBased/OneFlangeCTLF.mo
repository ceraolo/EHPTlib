within EHPTlib.MapBased;
model OneFlangeCTLF "Simple map-based model of an electric drive"
  extends Partial.PartialOneFlange;

  parameter Modelica.Units.SI.Torque tauMax=80 "Maximum torque"
    annotation (Dialog(enable=not limitsOnFile,group = "General parameters"));

 //Parameters related to the torque limits Combi-table:
  parameter Boolean normalisedInput = false "= true, input torque limits has speed and torque between 0 and 1 (will be multiplied by wMax and tauMax).
  Note: efficiency table is always assumed to have input torque and speed normalised."
  annotation(Evaluate=true, HideResult=true, choices(checkBox=true), Dialog(group = "Combi-table related parameters"));
  parameter Boolean limitsOnFile = false "= true, if torque limits are taken from a txt file" annotation (Dialog(group = "Combi-table related parameters"));
  parameter String limitsFileName = "noName" "File where limit matrices are stored" annotation (
    Dialog(group="Combi-table related parameters", enable = limitsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
  parameter String maxTorqueTableName = "noName" "Name of the on-file upper torque limit" annotation (
    Dialog(enable = limitsOnFile,group = "Combi-table related parameters"));
  parameter String minTorqueTableName = "noName" "Name of the on-file lower torque limit" annotation (
    Dialog(enable = limitsOnFile,group = "Combi-table related parameters"));

  //Parameters related to the loss-formula:
  parameter Real A = 0.006 "fixed losses" annotation (
    Dialog(group = "Loss-formula parameters"));
  parameter Real bT = 0.05 "torque losses coefficient"
                                                      annotation (
    Dialog(group = "Loss-formula parameters"));
  parameter Real bW = 0.02 "speed losses coefficient"
                                                     annotation (
    Dialog(group = "Loss-formula parameters"));
  parameter Real bP = 0.05 "power losses coefficient"
                                                     annotation (
    Dialog(group = "Loss-formula parameters"));

  final parameter Modelica.Units.SI.Torque nomTorque(fixed=false);  //actual Max torque value for consumption map (which in file is between 0 and 1)
  final parameter Modelica.Units.SI.AngularVelocity nomSpeed(fixed=false); //actual Max speed value for consumption map (which in file is between 0 and 1)

  SupportModels.MapBasedRelated.LimTorqueCT limTau(
    limitsOnFile=limitsOnFile,
    tauMax=tauMax,
    wMax=wMax,
    powMax=powMax,
    limitsFileName=limitsFileName,
    maxTorqueTableName=maxTorqueTableName,
    minTorqueTableName=minTorqueTableName)
    annotation (Placement(transformation(extent={{50,14},{30,38}})));
  SupportModels.MapBasedRelated.EfficiencyLF toElePow(
      A=A,
      bT=bT,
      bW=bW,
      bP=bP,
      tauMax=tauMax,
      powMax=powMax,
      wMax=wMax)
    annotation (Placement(transformation(extent={{-24,-52},{-44,-32}})));
  Modelica.Blocks.Math.Gain fromPuTorque1(k=nomTorque)      annotation (Placement(
        visible=true, transformation(
        origin={15,19},
        extent={{-5,-5},{5,5}},
        rotation=180)));
  Modelica.Blocks.Math.Gain fromPuTorque(k=nomTorque) annotation (Placement(
        visible=true, transformation(
        origin={15,37},
        extent={{-5,-5},{5,5}},
        rotation=180)));
  Modelica.Blocks.Math.Gain toPuSpeed(k=1/nomSpeed)    annotation (Placement(visible
        =true, transformation(
        origin={68,26},
        extent={{-6,-6},{6,6}},
        rotation=180)));
initial equation
  if normalisedInput then
    nomTorque=tauMax;
    nomSpeed=wMax;
  else
    nomTorque=1;
    nomSpeed=1;
  end if;

equation
  connect(toElePow.tau, variableLimiter.y) annotation (Line(points={{-22,-38},{-8,
          -38},{-8,-26},{-40,-26},{-40,30},{-37,30}},color={0,0,127}));
  connect(toElePow.w, wSensor.w)
    annotation (Line(points={{-22,-46},{84,-46},{84,35.2}}, color={0,0,127}));
  connect(toElePow.elePow, pDC.Pref) annotation (Line(points={{-44.6,-42},{-60,-42},
          {-60,0},{-79.8,0}},      color={0,0,127}));
  connect(limTau.w, toPuSpeed.y)
    annotation (Line(points={{52,26},{61.4,26}}, color={0,0,127}));
  connect(toPuSpeed.u, wSensor.w)
    annotation (Line(points={{75.2,26},{84,26},{84,35.2}}, color={0,0,127}));
  connect(limTau.yH, fromPuTorque.u) annotation (Line(points={{29,33.2},{26,33.2},
          {26,37},{21,37}}, color={0,0,127}));
  connect(fromPuTorque.y, variableLimiter.limit1)
    annotation (Line(points={{9.5,37},{8,38},{-14,38}}, color={0,0,127}));
  connect(fromPuTorque1.y, variableLimiter.limit2) annotation (Line(points={{9.5,
          19},{6,19},{6,22},{-14,22}}, color={0,0,127}));
  connect(fromPuTorque1.u, limTau.yL)
    annotation (Line(points={{21,19},{22,18.8},{29,18.8}}, color={0,0,127}));
  annotation (Icon(graphics={
                  Text(origin={-2.6552,25.7},
                     extent={{-65.3448,-29.7},{74.6551,-51.7}},
          textColor={238,46,47},
          textStyle={TextStyle.Italic},
          textString="CT-LF")}));
end OneFlangeCTLF;
