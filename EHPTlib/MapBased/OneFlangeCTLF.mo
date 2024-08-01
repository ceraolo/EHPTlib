within EHPTlib.MapBased;
model OneFlangeCTLF "Simple map-based model of an electric drive"
  extends Partial.PartialOneFlange;

  parameter Modelica.Units.SI.Torque tauMax=80 "Maximum torque"
    annotation (Dialog(enable=not limitsOnFile,group = "General parameters"));

 //Parameters related to the Combi-table:
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

  SupportModels.MapBasedRelated.LimTorqueCT limTau(
    limitsOnFile=limitsOnFile,
    tauMax=tauMax,
    wMax=wMax,
    powMax=powMax,
    limitsFileName=limitsFileName,
    maxTorqueTableName=maxTorqueTableName,
    minTorqueTableName=minTorqueTableName)
    annotation (Placement(transformation(extent={{48,18},{28,42}})));
  SupportModels.MapBasedRelated.EfficiencyLF toElePow(
      A=A,
      bT=bT,
      bW=bW,
      bP=bP,
      tauMax=tauMax,
      powMax=powMax,
      wMax=wMax)
    annotation (Placement(transformation(extent={{-24,-30},{-44,-10}})));
equation
  connect(variableLimiter.limit1, limTau.yH)
    annotation (Line(points={{-14,38},{-14,37.2},{27,37.2}},
                                                           color={0,0,127}));
  connect(variableLimiter.limit2, limTau.yL)
    annotation (Line(points={{-14,22},{-14,22.8},{27,22.8}},
                                                           color={0,0,127}));
  connect(limTau.w, wSensor.w)
    annotation (Line(points={{50,30},{84,30},{84,35.2}}, color={0,0,127}));
  connect(toElePow.tau, variableLimiter.y) annotation (Line(points={{-22,-16},{-10,
          -16},{-10,8},{-40,8},{-40,30},{-37,30}},   color={0,0,127}));
  connect(toElePow.w, wSensor.w)
    annotation (Line(points={{-22,-24},{84,-24},{84,35.2}}, color={0,0,127}));
  connect(toElePow.elePow, pDC.Pref) annotation (Line(points={{-44.6,-20},{-60,-20},
          {-60,0},{-79.8,0}},      color={0,0,127}));
  annotation (Icon(graphics={
                  Text(origin={-2.6552,27.7},
                     extent={{-65.3448,-29.7},{74.6551,-51.7}},
          textColor={238,46,47},
          textStyle={TextStyle.Italic},
          textString="CT-LF")}));
end OneFlangeCTLF;
