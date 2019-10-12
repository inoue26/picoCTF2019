for /f "delims=: " %%t in (test.txt) do (
  echo token = %%t
) 
