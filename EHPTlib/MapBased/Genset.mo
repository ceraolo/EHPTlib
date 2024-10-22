within EHPTlib.MapBased;
model Genset "GenSet GMS+GEN+SEngine"
  extends Partial.PartialGenset(
  gen(
    effMapOnFile = mapsOnFile,
    effTable=constGenEfficiency*[0, 0, 1; 0, 1, 1; 1, 1, 1],
    limitsOnFile = mapsOnFile, effTableName = efficiencyName),
  iceT(
    scMapOnFile=mapsOnFile,
    specificCons=constFuelConsumption*[0, 100, 200; 100, 1, 1; 200, 1, 1],
    tlMapOnFile=mapsOnFile,
    maxIceTau=maxTau*[0, 1.1; 100, 1.1]));
    
  ECUs.GMS gms(
    throttlePerWerr=throttlePerWerr,
    mapsFileName=mapsFileName,
    optiSpeedOnFile = mapsOnFile,
    tauLimitsOnFile = false,
    mtTable = [0, 1e9; 100, 1e9], osTableName = optiSpeedName)
    annotation (Placement(transformation(extent={{-70,12},{-50,32}})));
equation
  connect(gms.Wmecc, gain1.y) annotation (Line(points={{-60.1,10.5},{-60,10.5},
          {-60,0},{-80,0},{-80,-17.4}}, color={0,0,127}));
  connect(gms.tRef, gain.u) annotation (Line(points={{-49,28},{-38,28},{-38,34},
          {12,34}}, color={0,0,127}));
  connect(gms.throttle, iceT.nTauRef) annotation (Line(points={{-49,16},{-44,16},
          {-44,-24},{-24,-24},{-24,-20.2}}, color={0,0,127}));
  connect(gms.pRef, limiter.y)
    annotation (Line(points={{-72,22},{-80,22},{-80,37}}, color={0,0,127}));
  annotation (
    Documentation(info = "<html><head></head><body><p>Generator set containing Internal Combustion Engine (ICE), electric generator (with DC output), and the related control.</p>
<p>This model models a generator set, as the one present in a series-hybrid vehicle: it contains an Internal Combustion engine (ICE), coupled through an ideal reduction gear (set its ratio to 1 in case it is absent) to an electric generator (with DC output). </p>
<p>It contains also the control logic of this set, that asks the ICE deliver, using the optimal generator speed, the requested input power. Actual DC power will be lower, due to the generator efficiency.</p>
<p>The model can work at two levels of complexity (and modeling detail).</p><p><b>Level 1: Fixed limits, fixed consumption</b></p><p>At this level, the model will limit the torque internally exchanged between ICE and generator to maxTau, its speed to maxGenW, its power to maxGenPow.</p><p>to operate at this level, parameter mapsOnFile must be unselected (i.e., false).</p><p><b>Level 2: limits and consumption from a txt&nbsp;</b></p><p>At this level, the model will limit the torque internally exchanged between ICE and generator to matrices read from a txt file. The file and matrixs names can be inputted, while it is easier to stick with the default matrix names.&nbsp;</p><p>Input and output values to all matrices are multiplied by factors that are under user control. This allows using matrices with different units of measures (e.g. rpm or rad/s), and/or re-use matrices for devices with different maximum values, but limits and/or consumption with the same shape. If we, for instance, multiply input torque and speed by two, we can use torque limits referring to a machine having twice the maximum torque and speed, and the same shape between 0 and maxima. If we multiply output consumption by 0.8, we will have an engine with the same consumption map shape, but lower consumptions values by 20%.</p><p>***************</p><p>This model uses GMS, IceT and OneFlange EHPTlib models.</p><p>All of them allow implementing limitation of torque between iceT and gen. In genset, both ICE and gen keep their limitations, while GMS torque limitation is disabled through usage of very large limits.</p><p>IceT and gen torque limiations are different: gen has a near-symmetrical torque limitation, while ICE, as it is implemented has zero minimum torque. This does not create issues, since the power request to ICE is always positive, and therefore gen will never (or nearly never) apply accelerating torques to the ICE.</p>
</body></html>"));end Genset;
