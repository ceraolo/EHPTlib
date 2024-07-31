within EHPTlib.MapBased;
model OneFlangeCTLF "Simple map-based model of an electric drive"
  extends Partial.PartialOneFlange;

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

 //Parameters related to the Combi-table:
 parameter Boolean effMapOnFile = false "= true, if tables are taken from a txt file"  annotation (
    Dialog(group = "Combi-table related parameters"));
 parameter String limitsFileName = "noName" "File where limit matrices are stored" annotation (
    Dialog(group="Combi-table related parameters", enable = limitsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
  parameter Boolean limitsOnFile = false "= true, if torque limits are taken from a txt file" annotation (Dialog(enable=not limitsOnFile,group = "Combi-table related parameters"));
  parameter String mapsFileName = "noName" "File where efficiency/limits matrix/ces is/are stored" annotation (
    Dialog(group = "Combi-table related parameters",enable = effMapOnFile or limitsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));

  parameter String maxTorqueTableName = "noName" "Name of the on-file upper torque limit" annotation (
    Dialog(enable = limitsOnFile,group = "Combi-table related parameters"));
  parameter String minTorqueTableName = "noName" "Name of the on-file lower torque limit" annotation (
    Dialog(enable = limitsOnFile,group = "Combi-table related parameters"));
   parameter String effTableName = "noName" "Name of the on-file efficiency matrix" annotation (
    Dialog(enable = mapsOnFile,group = "Combi-table related parameters"));
  parameter Real effTable[:, :] = [0, 0, 1; 0, 1, 1; 1, 1, 1] "rows: speeds; columns: torques; both p.u. of max" annotation (
    Dialog(enable = not mapsOnFile,group = "Combi-table related parameters"));
  SupportModels.MapBasedRelated.LimTorqueCT limTau(
    limitsOnFile=limitsOnFile,
    tauMax=tauMax,
    wMax=wMax,
    powMax=powMax,
    limitsFileName=mapsFileName,
    maxTorqueTableName=maxTorqueTableName,
    minTorqueTableName=minTorqueTableName)
    annotation (Placement(transformation(extent={{44,18},{24,42}})));
  SupportModels.MapBasedRelated.EfficiencyCT toElePow(
    mapsOnFile=effMapOnFile,
    tauMax=tauMax,
    powMax=powMax,
    wMax=wMax,
    mapsFileName=mapsFileName,
    effTableName=effTableName,
    effTable=effTable)
    annotation (Placement(transformation(extent={{-24,-30},{-44,-10}})));
equation
  connect(variableLimiter.limit1, limTau.yH)
    annotation (Line(points={{-2,38},{-2,37.2},{23,37.2}}, color={0,0,127}));
  connect(variableLimiter.limit2, limTau.yL)
    annotation (Line(points={{-2,22},{-2,22.8},{23,22.8}}, color={0,0,127}));
  connect(limTau.w, wSensor.w)
    annotation (Line(points={{46,30},{78,30},{78,35.2}}, color={0,0,127}));
  connect(toElePow.elePow, gain.u) annotation (Line(points={{-44.6,-20},{-50,-20},
          {-50,0},{-62,0}}, color={0,0,127}));
  connect(toElePow.tau, variableLimiter.y) annotation (Line(points={{-22,-16},{-12,
          -16},{-12,10},{-36,10},{-36,30},{-25,30}}, color={0,0,127}));
  connect(toElePow.w, wSensor.w)
    annotation (Line(points={{-22,-24},{78,-24},{78,35.2}}, color={0,0,127}));
  annotation (Icon(graphics={
                  Text(origin={-2.6552,27.7},
                     extent={{-65.3448,-29.7},{74.6551,-51.7}},
          textColor={238,46,47},
          textStyle={TextStyle.Italic},
          textString="CT-LF")}));
end OneFlangeCTLF;
