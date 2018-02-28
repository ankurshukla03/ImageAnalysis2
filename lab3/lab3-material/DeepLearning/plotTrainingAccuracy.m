function plotTrainingAccuracy(info)

persistent plotObj

if info.State == "start"
    %plotObj = animatedline;
    plotObj = animatedline('Color','b','LineWidth',3);
    xlabel("Iteration")
    ylabel("Training Accuracy")
elseif info.State == "iteration"
    addpoints(plotObj,info.Iteration,info.TrainingAccuracy)
    drawnow limitrate nocallbacks
end

end