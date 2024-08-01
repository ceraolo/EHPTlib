within EHPTlib.MapBased;
model OneFlangeFVCT "Simple map-based model of an electric drive"
  extends Partial.PartialOneFlange;

  //Parameters related to both combi tables:
  parameter Modelica.Units.SI.Torque tauMax=80 "Maximum torque"
    annotation (Dialog(group = "General parameters"));
  parameter Boolean effMapOnFile = false "= true, if tables are taken from a txt file"  annotation (
    Dialog(group = "Combi-table related parameters"));
  parameter String mapsFileName = "noName" "File where efficiency table matrix is stored" annotation (
    Dialog(group = "Combi-table related parameters",enable = effMapOnFile, loadSelector(filter = "Text files (*.txt)",
    caption = "Open file in which required tables are")));

  parameter String effTableName = "noName" "Name of the on-file efficiency matrix" annotation (
    Dialog(enable = effMapOnFile,group = "Combi-table related parameters"));
  parameter Real effTable[:, :] = [0, 0, 1; 0, 1, 1; 1, 1, 1] "rows: speeds; columns: torques; both p.u. of max" annotation (
    Dialog(enable = not effMapOnFile,group = "Combi-table related parameters"));


  SupportModels.MapBasedRelated.EfficiencyCT toElePow(
    mapsOnFile=effMapOnFile,
    tauMax=tauMax,
    powMax=powMax,
    wMax=wMax,
    mapsFileName=mapsFileName,
    effTableName=effTableName,
    effTable=effTable)
    annotation (Placement(transformation(extent={{-24,-30},{-44,-10}})));
  SupportModels.MapBasedRelated.LimTorqueFV limTau(
    tauMax=tauMax,
    wMax=wMax,
    powMax=powMax)
    annotation (Placement(transformation(extent={{48,18},{28,42}})));
equation
  connect(variableLimiter.y, torque.tau) annotation (Line(points={{-37,30},{-40,
          30},{-40,60},{-18,60}}, color={0,0,127}));
  connect(variableLimiter.y, toElePow.tau) annotation (Line(points={{-37,30},{-40,
          30},{-40,8},{-10,8},{-10,-16},{-22,-16}}, color={0,0,127}));
  connect(wSensor.w, toElePow.w)
    annotation (Line(points={{84,35.2},{84,-24},{-22,-24}}, color={0,0,127}));
  connect(variableLimiter.limit2, limTau.yL)
    annotation (Line(points={{-14,22},{-14,22.8},{27,22.8}},
                                                           color={0,0,127}));
  connect(variableLimiter.limit1, limTau.yH)
    annotation (Line(points={{-14,38},{-14,37.2},{27,37.2}},
                                                           color={0,0,127}));
  connect(limTau.w, wSensor.w)
    annotation (Line(points={{50,30},{84,30},{84,35.2}}, color={0,0,127}));
  connect(toElePow.elePow, pDC.Pref) annotation (Line(points={{-44.6,-20},{-60,-20},
          {-60,0},{-79.8,0}},      color={0,0,127}));
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
          textString="FV-CT")}));
end OneFlangeFVCT;
