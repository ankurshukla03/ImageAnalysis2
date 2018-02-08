function compile_gc(debug_flag)

if strfind(computer(),'64')
    defs = '-DA64BITS '; % for 64bit machines - define pointer type
else
    defs = '';
end
% if mj < 7 || (mj==7 && mn < 3)
if verLessThan('matlab','7.3')    
    defs = [defs, '-DmwIndex=int -DmwSize=size_t '];
end

if nargin>0 && debug_flag
    debugs = ' -g ';
else
    debugs = ' -O ';
end

cmd = sprintf('mex %s -largeArrayDims %s GraphCutMex.cpp graph.cpp GCoptimization.cpp GraphCut.cpp LinkedBlockList.cpp maxflow.cpp',...
    debugs, defs);
eval(cmd);
cmd = sprintf('mex %s -largeArrayDims %s GraphCut3dConstr.cpp graph.cpp GCoptimization.cpp GraphCut.cpp LinkedBlockList.cpp maxflow.cpp',...
    debugs, defs);
eval(cmd);
cmd = sprintf('mex %s -largeArrayDims %s GraphCutConstrSparse.cpp graph.cpp GCoptimization.cpp GraphCut.cpp LinkedBlockList.cpp maxflow.cpp',...
    debugs, defs);
eval(cmd);
cmd = sprintf('mex %s -largeArrayDims %s GraphCutConstr.cpp graph.cpp GCoptimization.cpp GraphCut.cpp LinkedBlockList.cpp maxflow.cpp',...
    debugs, defs);
eval(cmd);
