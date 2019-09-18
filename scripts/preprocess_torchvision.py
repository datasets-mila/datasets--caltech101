import torchvision

torchvision.datasets.Caltech101(".", target_type="category", download=True)
torchvision.datasets.Caltech101(".", target_type="annotation", download=True)
