def parse_libsvm(file_path):
  data = []
  labels = []
  with open(file_path, "r") as f:
    for line in f:
      parts = line.strip().split()
      if not parts:
        continue
      label = float(parts[0])
      labels.append(label)

      features = {}
      for item in parts[1:]:
        idx_str, val_str = item.split(":")
        features[int(idx_str)] = float(val_str)
      data.append(features)
  return labels, data


# labels, features = parse_libsvm("data.libsvm")
