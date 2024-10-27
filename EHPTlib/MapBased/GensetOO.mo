within EHPTlib.MapBased;

model GensetOO "GenSet GMS+GEN+SEngine with On/Off"
  extends Partial.PartialGenset;
  Modelica.Blocks.Interfaces.BooleanInput ON "when true engine is ON" annotation(
    Placement(visible = true, transformation(origin = {-60, 82}, extent = {{10, -10}, {-10, 10}}, rotation = 90), iconTransformation(origin = {-60, 116}, extent = {{15, -15}, {-15, 15}}, rotation = 90)));
  ECUs.GMS gms(throttlePerWerr = throttlePerWerr, mapsFileName = mapsFileName, os_uFactor = osInFactor, os_yFactor = osOutFactor 
// Torque limitation in principle should be done by the HW, so ICE and Gen. 
// Further limitation in the GMS is in principle un-needed.
// However it has been seen that giving charge of this limitation only to HW 
// produces unacceptable results when genset power in involved in model SHEV_OO.
// It in not totally clear why this happens. Since, however, leaving in place 
// also the GM limtation does nor harm, it is left in place, and therefore the 
// following two rows are commented out.
//   ,tauLimitsOnFile=false,
//   mtTable = [0, 1e9; 100, 1e9]
  , optiSpeedOnFile = mapsOnFile, osTableName = optiSpeedName, tauLimitsOnFile = mapsOnFile, mtTable = [0, 1e9; 100, 1e9]) annotation(
    Placement(transformation(extent = {{-90, 6}, {-70, 26}})));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(transformation(extent = {{-22, 40}, {-10, 28}})));
  Modelica.Blocks.Sources.Constant zero(k = 0) annotation(
    Placement(transformation(extent = {{-52, 38}, {-40, 50}})));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(transformation(extent = {{-50, 14}, {-38, 2}})));
equation
  connect(gms.pRef, limiter.y) annotation(
    Line(points = {{-92, 16}, {-96, 16}, {-96, 32}, {-80, 32}, {-80, 37}}, color = {0, 0, 127}));
  connect(gms.Wmecc, gain1.y) annotation(
    Line(points = {{-80.1, 4.5}, {-80, 4.5}, {-80, -17.4}}, color = {0, 0, 127}));
  connect(gain.u, switch1.y) annotation(
    Line(points = {{12, 34}, {-9.4, 34}}, color = {0, 0, 127}));
  connect(switch1.u2, ON) annotation(
    Line(points = {{-23.2, 34}, {-60, 34}, {-60, 82}}, color = {255, 0, 255}));
  connect(zero.y, switch1.u3) annotation(
    Line(points = {{-39.4, 44}, {-36, 44}, {-36, 38.8}, {-23.2, 38.8}}, color = {0, 0, 127}));
  connect(switch1.u1, gms.tRef) annotation(
    Line(points = {{-23.2, 29.2}, {-30, 29.2}, {-30, 22}, {-69, 22}}, color = {0, 0, 127}));
  connect(switch2.u1, gms.throttle) annotation(
    Line(points = {{-51.2, 3.2}, {-64, 3.2}, {-64, 10}, {-69, 10}}, color = {0, 0, 127}));
  connect(switch2.u3, zero.y) annotation(
    Line(points = {{-51.2, 12.8}, {-54, 12.8}, {-54, 26}, {-36, 26}, {-36, 44}, {-39.4, 44}}, color = {0, 0, 127}));
  connect(switch2.y, iceT.nTauRef) annotation(
    Line(points = {{-37.4, 8}, {-34, 8}, {-34, -26}, {-24, -26}, {-24, -20.2}}, color = {0, 0, 127}));
  connect(switch2.u2, ON) annotation(
    Line(points = {{-51.2, 8}, {-60, 8}, {-60, 82}}, color = {255, 0, 255}));
  annotation(
    Documentation(info = "<html>
<p>For the general comments see info of Genset.</p>
<p>Here we have the ON-OFF input to command switching the ICE ON and OFF.</p>
</html>"));
end GensetOO;
