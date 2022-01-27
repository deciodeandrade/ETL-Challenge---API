module Algorithm

    def quicksort(array, first=0, last=nil)
        last = array.count - 1 if last.blank?
        if first < last
            p = partition(array, first, last)
            quicksort(array, first, p-1)
            quicksort(array, p+1, last)
        end
        array
    end

    private

    def partition(array, first, last)
        pivot = array[last]
        i = first
        (first..last-1).each do |j|
            if array[j] <= pivot
                array[j], array[i] = array[i], array[j]
                i = i + 1
            end
        end
        array[i], array[last] = array[last], array[i]
        return i
    end
end