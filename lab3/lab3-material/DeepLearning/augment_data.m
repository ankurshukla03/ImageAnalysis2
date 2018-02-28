%%++++ Load data-set
function augment_data(in_dir,out_dir,numrows,numcols,type,max_sz)

%if ~exist(out_dir, 'dir')
  mkdir(out_dir);
  
  % Get a list of all files and folders in this folder.
  files = dir(in_dir);
  % Get a logical vector that tells which is a directory.
  dirFlags = [files.isdir];
  % Extract only those that are directories.
  subFolders = files(dirFlags);
  % Print folder names to command window.
  for k = 3 : length(subFolders) % first two dirs are . and ..
      %fprintf('Sub folder #%d = %s\n', k, subFolders(k).name);
      in_subdir = fullfile(in_dir,subFolders(k).name);
      out_subdir = fullfile(out_dir,subFolders(k).name);
      if ~exist(out_subdir, 'dir')
          mkdir(out_subdir);
      end
      files = dir(in_subdir);
      % Get a logical vector that tells which is a file.
      fileFlags = ~[files.isdir];
      dataFiles = files(fileFlags);
      nFiles = min(max_sz,length(dataFiles));
      for i = 1 : nFiles
          %fprintf('File name #%d = %s\n', i, dataFiles(i).name);
          img = imread(fullfile(dataFiles(i).folder,dataFiles(i).name));
          imgNameExt = strsplit(dataFiles(i).name,'.');
              
          o_img = imresize(img,[numrows numcols]);
          if(numel(size(o_img)) == 2)
              out_img = cat(3, o_img, o_img, o_img);
          else
              out_img = o_img;
          end
          outName = fullfile(out_subdir,strcat(char(imgNameExt(1)),'.png'));
          imwrite(out_img, outName);
          
          if(strcmp(type,'rotation'))
              out_img = imRotateCrop(img,-5,'bilinear'); %clockwise 5 degrees
              out_img = imresize(out_img,[numrows numcols]);
              outName = fullfile(out_subdir,strcat(char(imgNameExt(1)),'c5.png'));
              imwrite(out_img, outName);
              
              out_img = imRotateCrop(img,-10,'bilinear'); %clockwise 10 degrees
              out_img = imresize(out_img,[numrows numcols]);
              outName = fullfile(out_subdir,strcat(char(imgNameExt(1)),'c10.png'));
              imwrite(out_img, outName);
              
              out_img = imRotateCrop(img,5,'bilinear'); %anti-clockwise 5 degrees
              out_img = imresize(out_img,[numrows numcols]);
              outName = fullfile(out_subdir,strcat(char(imgNameExt(1)),'a5.png'));
              imwrite(out_img, outName);
              
              out_img = imRotateCrop(img,10,'bilinear'); %anti-clockwise 10 degrees
              out_img = imresize(out_img,[numrows numcols]);
              outName = fullfile(out_subdir,strcat(char(imgNameExt(1)),'a10.png'));
              imwrite(out_img, outName);
          end
      end
  end
end
%end
