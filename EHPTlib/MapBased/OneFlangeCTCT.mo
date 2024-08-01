within EHPTlib.MapBased;
model OneFlangeCTCT "Simple map-based model of an electric drive"
  extends Partial.PartialOneFlange;

  parameter Modelica.Units.SI.Torque tauMax=80 "Maximum torque"
    annotation (Dialog(enable=not limitsOnFile,group = "General parameters"));
  //Parameters related to torque limits combi table:
  parameter Boolean normalisedInput = false "= true, input torque limits has speed and torque between 0 and 1 (will be multiplied by wMax and tauMax).
  Note: efficiency table is always assumed to have input torque and speed normalised."
  annotation(Evaluate=true, HideResult=true, choices(checkBox=true), Dialog(group = "Combi-table related parameters"));
  parameter Boolean limitsOnFile = false "= true, if torque limits are taken from a txt file" annotation (Dialog(group = "Combi-table related parameters"));
  parameter String limitsFileName = "noName" "File where efficiency table matrix is stored" annotation (
    Dialog(group = "Combi-table related parameters",enable = limitsOnFile, loadSelector(filter = "Text files (*.txt)",
    caption = "Open file in which required tables are")));
  parameter String maxTorqueTableName = "noName" "Name of the on-file upper torque limit" annotation (
    Dialog(enable = limitsOnFile,group = "Combi-table related parameters"));
  parameter String minTorqueTableName = "noName" "Name of the on-file lower torque limit" annotation (
    Dialog(enable = limitsOnFile,group = "Combi-table related parameters"));

  //Parameters related to efficiency combi table:
  parameter Boolean effMapOnFile = false "= true, if tables are taken from a txt file"  annotation (
    Dialog(group = "Combi-table related parameters"));
  parameter String effMapFileName = "noName" "File where efficiency table matrix is stored" annotation (
    Dialog(group = "Combi-table related parameters",enable = effMapOnFile, loadSelector(filter = "Text files (*.txt)",
    caption = "Open file in which required tables are")));
  parameter String effTableName = "noName" "Name of the on-file efficiency matrix" annotation (
    Dialog(enable = effMapOnFile,group = "Combi-table related parameters"));
  parameter Real effTable[:, :] = [0, 0, 1; 0, 1, 1; 1, 1, 1] "rows: speeds; columns: torques; both p.u. of max" annotation (
    Dialog(enable = not effMapOnFile,group = "Combi-table related parameters"));

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
  SupportModels.MapBasedRelated.EfficiencyCT toElePow(
    mapsOnFile=effMapOnFile,
    tauMax=tauMax,
    powMax=powMax,
    wMax=wMax,
    mapsFileName=effMapFileName,
    effTableName=effTableName,
    effTable=effTable)
    annotation (Placement(transformation(extent={{-16,-38},{-36,-18}})));
  Modelica.Blocks.Math.Gain fromPuTorque(k=nomTorque) annotation (Placement(
        visible=true, transformation(
        origin={15,37},
        extent={{-5,-5},{5,5}},
        rotation=180)));
  Modelica.Blocks.Math.Gain fromPuTorque1(k=nomTorque)      annotation (Placement(
        visible=true, transformation(
        origin={17,19},
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
  connect(variableLimiter.y, torque.tau) annotation (Line(points={{-37,30},{-40,
          30},{-40,60},{-18,60}}, color={0,0,127}));
  connect(variableLimiter.y, toElePow.tau) annotation (Line(points={{-37,30},{
          -40,30},{-40,-8},{-6,-8},{-6,-24},{-14,-24}},
                                                    color={0,0,127}));
  connect(wSensor.w, toElePow.w)
    annotation (Line(points={{84,35.2},{84,-32},{-14,-32}}, color={0,0,127}));
  connect(fromPuTorque1.u, limTau.yL)
    annotation (Line(points={{23,19},{24,18.8},{29,18.8}}, color={0,0,127}));
  connect(fromPuTorque.u, limTau.yH) annotation (Line(points={{21,37},{26,37},{26,
          33.2},{29,33.2}}, color={0,0,127}));
  connect(variableLimiter.limit1, fromPuTorque.y) annotation (Line(points={{-14,
          38},{4,38},{4,37},{9.5,37}}, color={0,0,127}));
  connect(variableLimiter.limit2, fromPuTorque1.y) annotation (Line(points={{-14,
          22},{6,22},{6,19},{11.5,19}}, color={0,0,127}));
  connect(limTau.w, toPuSpeed.y)
    annotation (Line(points={{52,26},{61.4,26}}, color={0,0,127}));
  connect(toPuSpeed.u, wSensor.w)
    annotation (Line(points={{75.2,26},{84,26},{84,35.2}}, color={0,0,127}));
  connect(toElePow.elePow, pDC.Pref) annotation (Line(points={{-36.6,-28},{-64,
          -28},{-64,0},{-79.8,0}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>This is a model that models an electric drive: electronic converter + electric machine.</p>
<p>The only model dynamics is its inertia. </p>
<p>The input signal is a torque request (Nm), which is applied to a mechanical inertia. </p>
<p>The maximum available torque is internally computed considering a direct torque maximum (tauMax) and a power maximum (powMax); the model then computes the inner losses and absorbs the total power from the DC input.</p>
<p>Note that to evaluate the inner losses the model uses an efficiency map (i.e. a table), in which torques are ratios of actual torques to tauMax and speeds are ratios of w to wMax. Because of this wMax must be supplied as a parameter.</p>
<p>Improvement onto OneFlange: now the user can implement max and minimum torque as a function of the angular speed, through curves supplied via an array taken from an input file: CTCT in the name means that both the maxiomum torque and the efficiency evaluation are CombiTable based.</p>
<p>This model is not parameter-compatible with OneFlange. This has caused this new model to be introduced. </p>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-80},{100,80}},        preserveAspectRatio = false, initialScale = 0.1)),
    Icon(coordinateSystem(extent={{-100,-80},{100,80}},       preserveAspectRatio = false, initialScale = 0.1),
        graphics={Text(origin={-2.52219,25.7},
                     extent={{-63.4778,-29.7},{72.5222,-51.7}},
          textColor={238,46,47},
          textStyle={TextStyle.Italic},
          textString="CT-CT")}));
end OneFlangeCTCT;
