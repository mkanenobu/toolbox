package hof

func Map[T, U any](list []T, f func(T) U) []U {
	result := make([]U, len(list))
	for _, v := range list {
		result = append(result, f(v))
	}
	return result
}

func Collect[T any](list []T, f func(T) bool) []T {
	result := make([]T, 0)
	for _, v := range list {
		if f(v) {
			result = append(result, v)
		}
	}
	return result
}
