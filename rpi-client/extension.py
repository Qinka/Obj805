
# ReLU for obj805

# Rectified Linear Unit
def ReLU(value):
  if value > 100:
    return 100
  elif value < 0:
    return 0
  else:
    return value

# Punishment Linear Unit    
def PuLU(value):
  if value > 100:
    return 0
  elif value < 0:
    return 100
  else:
    return 100 - value